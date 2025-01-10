import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MotionWidget extends StatefulWidget {
  final Widget child;
  final double sensitivity;
  final bool clip;
  final Curve curve;
  final Duration duration;

  const MotionWidget({
    Key? key,
    required this.child,
    this.sensitivity = 1.0,
    this.clip = true,
    this.curve = Curves.easeOut,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  State<MotionWidget> createState() => _MotionWidgetState();
}

class _MotionWidgetState extends State<MotionWidget> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _alignX = 0.0;
  double _alignY = 0.0;

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      if (mounted) {
        setState(() {
          // Convert accelerometer data to alignment values (-1 to 1)
          _alignX = (event.x * 0.5 * widget.sensitivity).clamp(-1.0, 1.0);
          _alignY = (event.y * 0.5 * widget.sensitivity).clamp(-1.0, 1.0);
        });
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base widget
        widget.child,
        
        // Corner light beam effect
        AnimatedContainer(
          duration: widget.duration,
          curve: widget.curve,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(_alignX, _alignY),
              radius: 0.4,
              colors: [
                Colors.grey[300]!.withOpacity(0.9),
                Colors.grey[200]!.withOpacity(0.4),
                Colors.transparent,
              ],
              stops: const [0.0, 0.4, 0.8],
            ),
          ),
        ),
        
        // Additional focused highlight
        AnimatedContainer(
          duration: widget.duration,
          curve: widget.curve,
          decoration: BoxDecoration(
            gradient: SweepGradient(
              center: Alignment(_alignX, _alignY),
              startAngle: 0,
              endAngle: 3.14159 / 2,
              colors: [
                Colors.grey[400]!.withOpacity(0.6),
                Colors.transparent,
              ],
              stops: const [0.0, 0.2],
            ),
          ),
        ),
      ],
    );
  }
} 