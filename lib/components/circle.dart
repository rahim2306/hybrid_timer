import 'package:flutter/material.dart';
import 'dart:ui' as ui; // Import for MaskFilter
import 'dart:math' as math; // Import for math.pi

// --- StaticCirclePainter (MODIFIED for more prominent glow) ---
class StaticCirclePainter extends CustomPainter {
  final Color circleColor;
  final double strokeWidth;
  final double glowRadius; // Changed from blurRadius to glowRadius for consistency

  StaticCirclePainter({
    this.circleColor = const Color(0xFFC9C1DC), // Pale lavender, similar to the image
    this.strokeWidth = 4.0, // Increased default stroke for visibility
    this.glowRadius = 15.0, // Increased default glow for more presence
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;

    // 1. Draw the "glow" layer (blurred stroke) for the static circle
    final Paint glowPaint = Paint()
      ..color = circleColor.withValues(alpha: 0.5) // Slightly less opaque for the outer glow
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2 // Wider for glow
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, glowRadius);

    canvas.drawCircle(center, radius, glowPaint);

    // 2. Draw a brighter, slightly less blurred layer for intensity for the static circle
    final Paint innerGlowPaint = Paint()
      ..color = circleColor // Full color for the core of the glow
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 1.5
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, glowRadius / 2);

    canvas.drawCircle(center, radius, innerGlowPaint);

    // 3. Draw the solid, crisp stroke on top for the static circle
    final Paint strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8) // A bright, crisp core
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, strokePaint);
  }

  @override
  bool shouldRepaint(covariant StaticCirclePainter oldDelegate) {
    return oldDelegate.circleColor != circleColor ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.glowRadius != glowRadius;
  }
}

// --- AnimatedNeonDashPainter (No changes, using withValues(alpha:)) ---
class AnimatedNeonDashPainter extends CustomPainter {
  final Color neonColor;
  final double strokeWidth;
  final double glowRadius;
  final double currentRotationAngle; // Overall rotation of the dash
  final double dashSweepAngle; // Length of the dash arc in radians

  AnimatedNeonDashPainter({
    required this.neonColor,
    this.strokeWidth = 6.0,
    this.glowRadius = 25.0,
    this.currentRotationAngle = 0.0,
    this.dashSweepAngle = math.pi / 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: size.width / 2 - strokeWidth / 2);

    final dashStartAngle = currentRotationAngle - dashSweepAngle / 2;

    final Paint glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2
      ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, glowRadius);

    final Paint dashPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final gradient = ui.Gradient.sweep(
      center,
      [
        neonColor,
        neonColor.withValues(alpha: 0.0), // Using withValues(alpha:)
      ],
      [
        0.0,
        1.0,
      ],
      TileMode.clamp,
      dashStartAngle,
      dashStartAngle + dashSweepAngle,
    );

    glowPaint.shader = gradient;
    dashPaint.shader = gradient;

    canvas.drawArc(rect, dashStartAngle, dashSweepAngle, false, glowPaint);
    canvas.drawArc(rect, dashStartAngle, dashSweepAngle, false, dashPaint);
  }

  @override
  bool shouldRepaint(covariant AnimatedNeonDashPainter oldDelegate) {
    return oldDelegate.neonColor != neonColor ||
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.glowRadius != glowRadius ||
           oldDelegate.currentRotationAngle != currentRotationAngle ||
           oldDelegate.dashSweepAngle != dashSweepAngle;
  }
}

// --- NeonGlowingCircleAndDash (Combines both painters) ---

class NeonGlowingCircleAndDash extends StatefulWidget {
  final Color neonDashColor;
  final Color staticCircleColor;
  final double size;
  final Widget? child;
  final double dashStrokeWidth;
  final double dashGlowRadius;
  final Duration animationDuration;
  final double dashSweepAngle;
  final double staticCircleStrokeWidth;
  final double staticCircleGlowRadius; // Changed parameter name for consistency

  const NeonGlowingCircleAndDash({
    super.key,
    this.neonDashColor = const Color(0xFF9033FF),
    this.staticCircleColor = const Color(0xFFC9C1DC),
    required this.size,
    this.child,
    this.dashStrokeWidth = 6.0,
    this.dashGlowRadius = 25.0,
    this.animationDuration = const Duration(seconds: 10),
    this.dashSweepAngle = math.pi / 3,
    this.staticCircleStrokeWidth = 4.0, // Default for more prominent static circle
    this.staticCircleGlowRadius = 15.0, // Default for more prominent static circle glow
  });

  @override
  _NeonGlowingCircleAndDashState createState() => _NeonGlowingCircleAndDashState();
}

class _NeonGlowingCircleAndDashState extends State<NeonGlowingCircleAndDash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: Stack( // Use Stack to layer the circle and the dash
        children: [
          // Background Static Circle
          Positioned.fill(
            child: CustomPaint(
              painter: StaticCirclePainter(
                circleColor: widget.staticCircleColor,
                strokeWidth: widget.staticCircleStrokeWidth,
                glowRadius: widget.staticCircleGlowRadius,
              ),
            ),
          ),
          // Animating Dash
          Positioned.fill(
            child: CustomPaint(
              painter: AnimatedNeonDashPainter(
                neonColor: widget.neonDashColor,
                strokeWidth: widget.dashStrokeWidth,
                glowRadius: widget.dashGlowRadius,
                currentRotationAngle: _animation.value,
                dashSweepAngle: widget.dashSweepAngle,
              ),
            ),
          ),
          // Child content (e.g., time)
          Center(
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

