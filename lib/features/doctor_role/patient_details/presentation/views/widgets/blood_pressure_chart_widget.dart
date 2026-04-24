import 'package:flutter/material.dart';

class BloodPressureChartWidget extends StatelessWidget {
  final List<double> readings;

  const BloodPressureChartWidget({
    super.key,
    required this.readings,
  });

  static const List<String> _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood Pressure Trend',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          const SizedBox(height: 16),

          // ── Chart ──
          SizedBox(
            height: 120,
            child: CustomPaint(
              painter: _LineChartPainter(
                readings: readings,
                lineColor: const Color(0xFF3B82F6),
                gridColor: Colors.grey.withOpacity(0.2),
              ),
              child: Container(),
            ),
          ),

          const SizedBox(height: 8),

          // ── Day labels ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _days
                .map(
                  (day) => Text(
                    day,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> readings;
  final Color lineColor;
  final Color gridColor;

  _LineChartPainter({
    required this.readings,
    required this.lineColor,
    required this.gridColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (readings.isEmpty) return;

    final double maxVal = readings.reduce((a, b) => a > b ? a : b) + 20;
    final double minVal = readings.reduce((a, b) => a < b ? a : b) - 20;
    final double range = maxVal - minVal;

    // Grid lines
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Line
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < readings.length; i++) {
      final x = size.width * i / (readings.length - 1);
      final y = size.height - (readings[i] - minVal) / range * size.height;
      points.add(Offset(x, y));
    }

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, linePaint);

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
      canvas.drawCircle(
        point,
        4,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}