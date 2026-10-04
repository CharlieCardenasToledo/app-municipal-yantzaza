import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Quiet Amazonian texture shared by the civic experience.
/// The foliage is intentionally low-contrast so content remains primary.
class AmazonianBackdrop extends StatelessWidget {
  final Widget child;

  const AmazonianBackdrop({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _AmazonianBackdropPainter(),
      child: child,
    );
  }
}

class AmazonianBird extends StatefulWidget {
  final String asset;
  final double width;
  final Duration duration;

  const AmazonianBird({
    super.key,
    required this.asset,
    required this.width,
    this.duration = const Duration(milliseconds: 2800),
  });

  @override
  State<AmazonianBird> createState() => _AmazonianBirdState();
}

class _AmazonianBirdState extends State<AmazonianBird>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        builder: (context, child) {
          final offset = -5 * Curves.easeInOut.transform(_controller.value);
          return Transform.translate(offset: Offset(0, offset), child: child);
        },
        child: Image.asset(
          widget.asset,
          width: widget.width,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}

class _AmazonianBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final leafPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.primary.withValues(alpha: 0.035);
    final accentPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppColors.secondary.withValues(alpha: 0.035);

    _paintFrond(
      canvas,
      origin: Offset(size.width - 18, -18),
      length: size.width.clamp(180, 420).toDouble() * 0.7,
      angle: 2.32,
      paint: leafPaint,
    );
    _paintFrond(
      canvas,
      origin: Offset(12, size.height + 22),
      length: size.width.clamp(160, 360).toDouble() * 0.58,
      angle: -0.86,
      paint: accentPaint,
    );
    _paintLeafCluster(
      canvas,
      center: Offset(size.width * 0.92, size.height * 0.48),
      scale: 0.75,
      paint: leafPaint,
    );
  }

  void _paintFrond(
    Canvas canvas, {
    required Offset origin,
    required double length,
    required double angle,
    required Paint paint,
  }) {
    final stemEnd = origin + Offset(length * 0.45 * math.cos(angle), length * 0.45 * math.sin(angle));
    canvas.drawLine(origin, stemEnd, paint..strokeWidth = 2);
    for (var i = 0; i < 7; i++) {
      final progress = (i + 1) / 8;
      final center = Offset.lerp(origin, stemEnd, progress)!;
      _leaf(canvas, center, length * (0.14 - progress * 0.008), angle + 0.78, paint);
      _leaf(canvas, center, length * (0.12 - progress * 0.006), angle - 0.78, paint);
    }
  }

  void _paintLeafCluster(
    Canvas canvas, {
    required Offset center,
    required double scale,
    required Paint paint,
  }) {
    for (var i = 0; i < 5; i++) {
      final angle = -1.9 + i * 0.32;
      _leaf(canvas, center, 52 * scale, angle, paint);
    }
  }

  void _leaf(Canvas canvas, Offset center, double length, double angle, Paint paint) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.drawOval(Rect.fromCenter(center: Offset(length * 0.45, 0), width: length, height: length * 0.34), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
