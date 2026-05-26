import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme.dart';

/// Solar High-Density Crystalline Panel
/// Implements "Tonal Layering" and Glassmorphism for the Light Theme.
class NeonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const NeonCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Soft ambient depth shadow
          BoxShadow(
            color: ClubOsTheme.primaryCommand.withOpacity(0.04),
            blurRadius: 24,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: CustomPaint(
              painter: _SolarPainter(borderRadius: 16),
              child: Container(
                padding: padding ?? EdgeInsets.all(ClubOsTheme.gutter),
                decoration: BoxDecoration(
                  color: ClubOsTheme.solarSurfaceLowest.withOpacity(ClubOsTheme.isDark ? 0.35 : 0.6), // Crystalline surface
                  borderRadius: BorderRadius.circular(16),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SolarPainter extends CustomPainter {
  final double borderRadius;

  _SolarPainter({required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(borderRadius));
    
    // 1. Base crystalline border
    final Paint basePaint = Paint()
      ..color = ClubOsTheme.outlineVariant.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(rrect, basePaint);

    // 2. Solar Flare Corner Highlight (Top-left)
    final Path highlightPath = Path()
      ..moveTo(0, 40)
      ..lineTo(0, borderRadius)
      ..quadraticBezierTo(0, 0, borderRadius, 0)
      ..lineTo(40, 0);

    final Paint highlightPaint = Paint()
      ..shader = LinearGradient(
        colors: [ClubOsTheme.primaryCommand, ClubOsTheme.primaryContainer],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(highlightPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
