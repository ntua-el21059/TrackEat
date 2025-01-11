import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class _SocialProfileViewProfileState extends State<SocialProfileViewProfile> {
  bool _isProcessing = false;

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
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
    );
  }
} 