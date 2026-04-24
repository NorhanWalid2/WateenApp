import 'package:flutter/material.dart';

class MedicalHistoryWidget extends StatelessWidget {
  final List<String> history;

  const MedicalHistoryWidget({
    super.key,
    required this.history,
  });

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
            'Medical History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...history.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.inverseSurface,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
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