import 'package:flutter/material.dart';

class AppointmentSummaryStripWidget extends StatelessWidget {
  final String date;
  final String time;
  final String type;
  final String fee;

  const AppointmentSummaryStripWidget({
    super.key,
    required this.date,
    required this.time,
    required this.type,
    required this.fee,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF9),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFCCFBF1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryItem(label: 'Date', value: date),
          _Divider(),
          _SummaryItem(label: 'Time', value: time),
          _Divider(),
          _SummaryItem(label: 'Type', value: type),
          _Divider(),
          _SummaryItem(label: 'Fee', value: fee),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D9488),
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFFCCFBF1),
    );
  }
}