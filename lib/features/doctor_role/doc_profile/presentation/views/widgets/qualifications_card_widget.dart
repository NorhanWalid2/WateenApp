import 'package:flutter/material.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/data/models/doctor_profile_model.dart';

class DoctorQualificationsCardWidget extends StatelessWidget {
  final List<DoctorQualificationModel> qualifications;

  const DoctorQualificationsCardWidget({
    super.key,
    required this.qualifications,
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
                Icons.school_rounded,
                size: 20,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Qualifications & Education',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...qualifications.map(
            (q) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.degree,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          q.institution,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .outlineVariant,
                          ),
                        ),
                      ],
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