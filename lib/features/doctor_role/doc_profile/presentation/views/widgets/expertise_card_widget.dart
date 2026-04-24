import 'package:flutter/material.dart';

class DoctorExpertiseCardWidget extends StatelessWidget {
  final List<String> expertise;

  const DoctorExpertiseCardWidget({
    super.key,
    required this.expertise,
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
          Row(
            children: [
              Icon(
                Icons.medical_services_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Areas of Expertise',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: expertise
                .map(
                  (item) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
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