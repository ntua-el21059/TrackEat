import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../models/award_model.dart';
import '../models/user_model.dart';
import '../providers/social_profile_provider.dart';
import '../providers/social_awards_provider.dart';
import '../core/utils/size_utils.dart';
import '../presentation/challenge_award_screen/challenge_award_screen.dart';

class SocialProfileViewProfile extends StatefulWidget {
  final String email;

  const SocialProfileViewProfile({Key? key, required this.email}) : super(key: key);

  @override
  _SocialProfileViewProfileState createState() => _SocialProfileViewProfileState();
}

class _SocialProfileViewProfileState extends State<SocialProfileViewProfile> {
  bool _isProcessing = false;
  late SocialProfileProvider _profileProvider;
  late SocialAwardsProvider _awardsProvider;
  bool _isInitialLoadComplete = false;

  Stream<bool> checkFriendStatus() {
    return FirebaseFirestore.instance
        .collection('friends')
        .where('followerId', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .where('followingId', isEqualTo: widget.email)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Future<void> handleButtonPress(bool isFriend) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      if (!isFriend) {
        await FirebaseFirestore.instance.collection('friends').add({
          'followerId': FirebaseAuth.instance.currentUser!.email,
          'followingId': widget.email,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        final friendsRef = FirebaseFirestore.instance.collection('friends');
        final querySnapshot = await friendsRef
            .where('followerId', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .where('followingId', isEqualTo: widget.email)
            .get();

        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
      }
    } catch (e) {
      if (!e.toString().contains('permission-denied') && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _profileProvider.prefetchProfile(widget.email),
      _awardsProvider.prefetchAwards(widget.email),
    ]);
    if (mounted) {
      setState(() {
        _isInitialLoadComplete = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _profileProvider = Provider.of<SocialProfileProvider>(context, listen: false);
    _awardsProvider = Provider.of<SocialAwardsProvider>(context, listen: false);
    _loadInitialData();
  }

  Widget _buildProfileInfo() {
    if (!_isInitialLoadComplete) {
      final profile = _profileProvider.getProfile(widget.email);
      if (profile != null) {
        return _buildProfileContent(profile);
      }
      return const SizedBox(height: 80);
    }

    return StreamBuilder<UserModel?>(
      stream: _profileProvider.watchProfile(widget.email),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error loading profile'));
        }

        final profile = snapshot.data ?? _profileProvider.getProfile(widget.email);
        if (profile == null) {
          return const SizedBox(height: 80);
        }

        return _buildProfileContent(profile);
      },
    );
  }

  Widget _buildProfileContent(UserModel profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${profile.firstName} ${profile.lastName}',
            style: Theme.of(context).textTheme.titleLarge),
        if (profile.username != null)
          Text('@${profile.username}',
              style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAwardsGrid(BuildContext context) {
    if (!_isInitialLoadComplete) {
      final awards = _awardsProvider.getAwards(widget.email);
      if (awards != null) {
        return _buildAwardsContent(awards);
      }
      return const SizedBox(height: 100);
    }

    return StreamBuilder<List<Award>>(
      stream: _awardsProvider.watchAwards(widget.email),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }

        final awards = snapshot.data ?? _awardsProvider.getAwards(widget.email) ?? [];
        return _buildAwardsContent(awards);
      },
    );
  }

  Widget _buildAwardsContent(List<Award> awards) {
    if (awards.isEmpty) {
      return const Center(
        child: Text(
          'No awards yet',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 36.h) / 3;
          return Wrap(
            spacing: 18.h,
            runSpacing: 18.h,
            children: awards.map((award) => SizedBox(
              width: itemWidth,
              child: _buildAwardItem(award),
            )).toList(),
          );
        },
      ),
    );
  }

  Widget _buildAwardItem(Award award) {
    return GestureDetector(
      onTap: award.isAwarded ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChallengeAwardScreen.builder(
              context,
              award: award,
            ),
          ),
        );
      } : null,
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(award.isAwarded ? 0.5 : 0.1),
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Opacity(
                opacity: award.isAwarded ? 1.0 : 0.3,
                child: Image.asset(
                  award.picture,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error));
                  },
                ),
              ),
            ),
            if (!award.isAwarded)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(8.h),
                child: Icon(
                  Icons.lock,
                  color: Colors.black.withOpacity(0.7),
                  size: 28.h,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile: ${widget.email}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfo(),
            StreamBuilder<bool>(
              stream: checkFriendStatus(),
              builder: (context, snapshot) {
                final isFriend = snapshot.data ?? false;
                
                return ElevatedButton(
                  onPressed: _isProcessing ? null : () => handleButtonPress(isFriend),
                  child: Text(isFriend ? "Added" : "Add"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFriend ? Colors.grey : Colors.blue,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildAwardsGrid(context),
          ],
        ),
      ),
    );
  }
} 