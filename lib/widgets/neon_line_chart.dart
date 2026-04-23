import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../theme.dart';

class NeonLineChart extends StatefulWidget {
  final List<double> dataPoints;
  final double height;
  final double width;

  const NeonLineChart({
    super.key,
    required this.dataPoints,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  State<NeonLineChart> createState() => _NeonLineChartState();
}

class _NeonLineChartState extends State<NeonLineChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.width, widget.height),
          painter: _SolarChartPainter(
            dataPoints: widget.dataPoints,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class _SolarChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final double animationValue;

  _SolarChartPainter({required this.dataPoints, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final double stepX = size.width / (dataPoints.length - 1);
    final double maxY = dataPoints.reduce((a, b) => a > b ? a : b);
    final double scaleY = maxY == 0 ? 0 : size.height / maxY;

    final Path path = Path();
    for (int i = 0; i < dataPoints.length; i++) {
      final double x = i * stepX * animationValue;
      final double y = size.height - (dataPoints[i] * scaleY);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        final double prevX = (i - 1) * stepX * animationValue;
        final double prevY = size.height - (dataPoints[i - 1] * scaleY);
        path.cubicTo((prevX + x) / 2, prevY, (prevX + x) / 2, y, x, y);
      }
    }

    // 1. Solar Area Fill
    final Path fillPath = Path.from(path);
    fillPath.lineTo(size.width * animationValue, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(0, size.height),
        [
          ClubOsTheme.primaryCommand.withOpacity(0.08),
          ClubOsTheme.primaryCommand.withOpacity(0.0),
        ],
      );
    canvas.drawPath(fillPath, fillPaint);

    // 2. Data Pulse Shadow
    final Paint glowPaint = Paint()
      ..color = ClubOsTheme.primaryCommand.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, glowPaint);

    // 3. Technical Core Line
    final Paint linePaint = Paint()
      ..color = ClubOsTheme.primaryCommand
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);
    
    // 4. Activity Nodes (Dots)
    final Paint nodePaint = Paint()..color = ClubOsTheme.primaryCommand;
    final Paint innerNodePaint = Paint()..color = Colors.white;
    
    for (int i = 0; i < dataPoints.length; i++) {
      if (i % 2 == 0) { // Every second node for density management
        final double x = i * stepX * animationValue;
        final double y = size.height - (dataPoints[i] * scaleY);
        canvas.drawCircle(Offset(x, y), 4, nodePaint);
        canvas.drawCircle(Offset(x, y), 2, innerNodePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SolarChartPainter oldDelegate) => true;
}
