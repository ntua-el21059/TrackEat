import 'dart:math';
import 'dart:ui';
import '../../core/app_export.dart';
import 'provider/reward_screen_new_award_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RewardScreenNewAwardScreen extends StatefulWidget {
  const RewardScreenNewAwardScreen({Key? key}) : super(key: key);

  @override
  RewardScreenNewAwardScreenState createState() =>
      RewardScreenNewAwardScreenState();

  static Widget builder(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return ChangeNotifierProvider(
      create: (context) => RewardScreenNewAwardProvider(
        awardId: args?['awardId'] ?? '',
        awardName: args?['awardName'] ?? 'New Award',
        awardDescription: args?['awardDescription'] ?? 'Congratulations on your achievement!',
        awardPicture: args?['awardPicture'] ?? 'assets/images/vector.png',
        awardPoints: args?['awardPoints'] ?? 0,
        awardedTime: args?['awardedTime'] ?? DateTime.now(),
      ),
      child: const RewardScreenNewAwardScreen(),
    );
  }
}

class Particle {
  Offset position;
  Color color;
  double size;
  double velocityY;
  double rotation;
  int shape; // 0: rectangle, 1: diamond

  Particle({
    required this.position,
    required this.color,
    required this.size,
    required this.shape,
    this.velocityY = 2.0,
    required this.rotation,
  });
}

class RewardScreenNewAwardScreenState extends State<RewardScreenNewAwardScreen> with TickerProviderStateMixin {
  bool _isNavigating = false;
  double _alignX = 0.0;
  double _alignY = 0.0;
  double _smoothX = 0.0;
  double _smoothY = 0.0;
  static const double _sensitivity = 0.8;
  static const double _smoothingFactor = 0.7;
  bool _isInitialized = false;

  final List<Particle> _particles = [];
  late AnimationController _animationController;
  final Random _random = Random();

  static const List<Color> _colors = [
    Color(0xFFFF1D44), // Red
    Color(0xFFFFD100), // Gold
    Color(0xFF00E0FF), // Blue
    Color(0xFFFF8D00), // Orange
    Color(0xFFFFFFFF), // White
    Color(0xFF00FF94), // Green
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _animationController.addListener(_updateParticles);

    accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          final targetX = (-event.x * _sensitivity).clamp(-1.0, 1.0);
          _smoothX = _smoothX * _smoothingFactor + targetX * (1 - _smoothingFactor);
          _alignX = _smoothX;
        });
      }
    });
  }

  void _generateParticles(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _particles.clear();

    for (int i = 0; i < 100; i++) {
      _particles.add(
        Particle(
          position: Offset(
            _random.nextDouble() * size.width,
            -size.height + (_random.nextDouble() * size.height * 2),
          ),
          color: _colors[_random.nextInt(_colors.length)],
          size: 2 + _random.nextDouble() * 3,
          shape: _random.nextInt(2),
          rotation: _random.nextDouble() * pi * 2,
        ),
      );
    }
  }

  void _updateParticles() {
    if (!mounted || !_isInitialized) return;

    final size = MediaQuery.of(context).size;
    for (var particle in _particles) {
      final swayAmount = sin(_animationController.value * pi * 2) * 0.5;

      particle.position = Offset(
        particle.position.dx + _alignX * 6 + swayAmount,
        particle.position.dy + particle.velocityY,
      );

      particle.rotation += 0.05 + (swayAmount.abs() * 0.05);

      if (particle.position.dy > size.height) {
        particle.position = Offset(
          _random.nextDouble() * size.width,
          -particle.size * 2,
        );
        particle.rotation = _random.nextDouble() * pi * 2;
      }

      if (particle.position.dx < -particle.size * 3) {
        particle.position = Offset(size.width + particle.size * 3, particle.position.dy);
      } else if (particle.position.dx > size.width + particle.size * 3) {
        particle.position = Offset(-particle.size * 3, particle.position.dy);
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateBack() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.email != null) {
      final provider = Provider.of<RewardScreenNewAwardProvider>(context, listen: false);
      try {
        // Update award's awarded timestamp
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .collection('awards')
            .doc(provider.awardId)
            .update({
              'awarded': FieldValue.serverTimestamp(),
            });

        // Get current user points and update them
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser?.email)
            .get();
        
        if (userDoc.exists) {
          final currentPoints = userDoc.data()?['points'] as int? ?? 0;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser?.email)
              .update({
                'points': currentPoints + 50
              });
        }
      } catch (e) {
        print('Error updating award timestamp or points: $e');
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _generateParticles(context);
        _isInitialized = true;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        _navigateBack();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.onErrorContainer,
        body: SafeArea(
          child: Consumer<RewardScreenNewAwardProvider>(
            builder: (context, provider, _) {
              return Stack(
                children: [
                  // Particles
                  CustomPaint(
                    painter: ParticlePainter(particles: _particles),
                    size: Size.infinite,
                  ),

                  // Main content
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.h,
                      vertical: 24.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Congratulations!",
                          style: theme.textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "New Award Unlocked!",
                          style: theme.textTheme.displayMedium?.copyWith(
                            fontSize: (theme.textTheme.displayMedium?.fontSize ?? 32) * 0.7,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: 240.h,
                          height: 240.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(120.h),
                          ),
                          child: Center(
                            child: Image.asset(
                              provider.awardPicture,
                              width: 180.h,
                              height: 180.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "+${provider.awardPoints} points",
                          style: TextStyle(
                            fontSize: 24.h,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4CD964),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Dismiss button
                  Positioned(
                    bottom: 50.h,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.h),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _navigateBack,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32.h,
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20.h),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.15),
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  "Dismiss",
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.9),
                                    fontSize: 17.h,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      if (particle.shape == 0) {
        // Rectangle confetti
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: particle.size * 3,
          height: particle.size,
        );
        canvas.drawRect(rect, paint);
      } else {
        // Diamond confetti
        final path = Path();
        path.moveTo(0, -particle.size * 1.5);
        path.lineTo(particle.size, 0);
        path.lineTo(0, particle.size * 1.5);
        path.lineTo(-particle.size, 0);
        path.close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
