import 'dart:math';
import 'dart:ui';
import '../../core/app_export.dart';
import 'provider/reward_screen_rings_closed_provider.dart';
import '../homepage_history/home_screen/provider/home_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RewardScreenRingsClosedScreen extends StatefulWidget {
  const RewardScreenRingsClosedScreen({super.key});

  @override
  RewardScreenRingsClosedScreenState createState() =>
      RewardScreenRingsClosedScreenState();

  static Widget builder(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RewardScreenRingsClosedProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
      ],
      child: const RewardScreenRingsClosedScreen(),
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
    this.velocityY = 2.0, // Reduced falling speed from 4.0
    required this.rotation,
  });
}

class RewardScreenRingsClosedScreenState
    extends State<RewardScreenRingsClosedScreen> with TickerProviderStateMixin {
  bool _isNavigating = false;
  double _alignX = 0.0;
  double _smoothX = 0.0;
  static const double _sensitivity = 0.8; // Decreased sensitivity
  static const double _smoothingFactor =
      0.7; // Less smoothing for faster response
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

    // Create animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Add listener for animation updates
    _animationController.addListener(_updateParticles);

    // Listen to accelerometer events with smoothing
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          // Only use X-axis for side-to-side movement
          final targetX = (-event.x * _sensitivity).clamp(-1.0, 1.0);

          // Apply smoothing only to X movement
          _smoothX =
              _smoothX * _smoothingFactor + targetX * (1 - _smoothingFactor);
          _alignX = _smoothX;
        });
      }
    });
  }

  void _generateParticles(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _particles.clear();

    // Create particles distributed across the screen vertically
    for (int i = 0; i < 100; i++) {
      // Increased from 50 to 100 particles
      _particles.add(
        Particle(
          position: Offset(
            _random.nextDouble() * size.width,
            // Distribute particles across twice the screen height for smoother initial flow
            -size.height + (_random.nextDouble() * size.height * 2),
          ),
          color: _colors[_random.nextInt(_colors.length)],
          size: 2 +
              _random.nextDouble() * 3, // Slightly smaller size for denser look
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
      // Add some natural swaying motion
      final swayAmount = sin(_animationController.value * pi * 2) * 0.5;

      particle.position = Offset(
        particle.position.dx +
            _alignX * 6 +
            swayAmount, // Reduced horizontal movement speed from 12 to 6
        particle.position.dy + particle.velocityY,
      );

      // Rotate based on movement
      particle.rotation += 0.05 + (swayAmount.abs() * 0.05);

      // Reset particle position when it goes off screen
      if (particle.position.dy > size.height) {
        // Reset to above the screen at a random x position
        particle.position = Offset(
          _random.nextDouble() * size.width,
          -particle.size * 2,
        );
        particle.rotation = _random.nextDouble() * pi * 2;
      }

      // Wrap particles horizontally (appear on opposite side)
      if (particle.position.dx < -particle.size * 3) {
        particle.position =
            Offset(size.width + particle.size * 3, particle.position.dy);
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

  void _navigateToHome() async {
    if (_isNavigating) return;

    setState(() {
      _isNavigating = true;
    });

    // Add 50 points to the user's total points
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();
      
      if (userDoc.exists) {
        final currentPoints = userDoc.data()?['points'] as int? ?? 0;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .update({'points': currentPoints + 50});
      }
    }

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    await homeProvider.markRewardScreenAsShown();

    if (!mounted) return;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.homeScreen,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize particles after first build
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _generateParticles(context);
        _isInitialized = true;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        _navigateToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.onErrorContainer,
        body: SafeArea(
          child: Stack(
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
                    SizedBox(height: 16.h),
                    Text(
                      "You reached your daily calorie goal!",
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "+50 points",
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
                          onTap: _navigateToHome,
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
