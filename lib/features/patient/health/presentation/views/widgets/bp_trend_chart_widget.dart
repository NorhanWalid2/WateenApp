import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BpTrendChartWidget extends StatelessWidget {
  const BpTrendChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final systolicSpots = [
      const FlSpot(0, 118), const FlSpot(1, 122), const FlSpot(2, 119),
      const FlSpot(3, 125), const FlSpot(4, 121), const FlSpot(5, 120),
      const FlSpot(6, 123),
    ];
    final diastolicSpots = [
      const FlSpot(0, 76), const FlSpot(1, 80), const FlSpot(2, 78),
      const FlSpot(3, 82), const FlSpot(4, 79), const FlSpot(5, 80),
      const FlSpot(6, 81),
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          // ── Legend ───────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _LegendDot(color: const Color(0xFFE53935), label: 'Systolic'),
              const SizedBox(width: 16),
              _LegendDot(color: const Color(0xFF1E88E5), label: 'Diastolic'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                minY: 60,
                maxY: 150,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 30,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: colorScheme.outline.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 30,
                      reservedSize: 32,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}',
                        style: textTheme.bodySmall
                            ?.copyWith(fontSize: 10,
                                color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(
                        days[v.toInt()],
                        style: textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: systolicSpots,
                    isCurved: true,
                    color: const Color(0xFFE53935),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFFE53935).withOpacity(0.08),
                    ),
                  ),
                  LineChartBarData(
                    spots: diastolicSpots,
                    isCurved: true,
                    color: const Color(0xFF1E88E5),
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF1E88E5).withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontSize: 11)),
      ],
    );
  }
}