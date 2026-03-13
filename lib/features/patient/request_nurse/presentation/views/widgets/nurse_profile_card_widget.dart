import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';

class NurseProfileCardWidget extends StatelessWidget {
  final NurseModel nurse;

  const NurseProfileCardWidget({super.key, required this.nurse});

  List<Color> _avatarGradient() {
    final gradients = [
      [const Color(0xFF7C3AED), const Color(0xFFA78BFA)],
      [const Color(0xFF4F46E5), const Color(0xFF818CF8)],
      [const Color(0xFF6D28D9), const Color(0xFF8B5CF6)],
      [const Color(0xFF5B21B6), const Color(0xFF7C3AED)],
    ];
    final index = nurse.initials.codeUnitAt(0) % gradients.length;
    return gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _avatarGradient();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
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
          // Top row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large avatar
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    nurse.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name + specialty + stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nurse.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      nurse.specialty,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF59E0B),
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${nurse.rating} (${nurse.reviewCount})',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${nurse.yearsExperience} yrs exp',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Rate
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rate',
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).colorScheme.outlineVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'SAR ${nurse.hourlyRate.toInt()}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7C3AED),
                      height: 1.1,
                    ),
                  ),
                  const Text(
                    '/hr',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7C3AED),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Theme.of(context).colorScheme.surface),
          const SizedBox(height: 16),

          // Info grid
          Row(
            children: [
              _InfoItem(
                label: 'Availability',
                value: nurse.isAvailable ? '● Available Now' : '● Unavailable',
                valueColor:
                    nurse.isAvailable
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFEF4444),
              ),
              const SizedBox(width: 10),
              _InfoItem(label: 'Service Type', value: 'Home Visit'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _InfoItem(
                label: 'Experience',
                value: '${nurse.yearsExperience} Years',
              ),
              const SizedBox(width: 10),
              _InfoItem(
                label: 'Completed Jobs',
                value: '${nurse.completedJobs} sessions',
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Skills
          Text(
            'SPECIALIZATIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.outlineVariant,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children:
                nurse.skills
                    .map(
                      (skill) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F3FF),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFDDD6FE)),
                        ),
                        child: Text(
                          skill,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF7C3AED),
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

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoItem({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.outlineVariant,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color:
                    valueColor ?? Theme.of(context).colorScheme.inverseSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
