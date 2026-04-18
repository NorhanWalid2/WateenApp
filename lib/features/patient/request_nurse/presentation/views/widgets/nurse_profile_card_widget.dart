import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';

class NurseProfileCardWidget extends StatelessWidget {
  final NurseModel nurse;

  const NurseProfileCardWidget({super.key, required this.nurse});

  List<Color> _avatarGradient(ColorScheme cs) {
    final gradients = [
      [cs.secondary, cs.secondary.withOpacity(0.7)],
      [const Color(0xFFB91C1C), const Color(0xFFEF4444)],
      [const Color(0xFF991B1B), cs.secondary],
      [const Color(0xFFDC2626), const Color(0xFFFCA5A5)],
    ];
    final index = nurse.initials.codeUnitAt(0) % gradients.length;
    return gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gradient = _avatarGradient(colorScheme);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.primary,
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
          // ── Top row ─────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
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
                        color: colorScheme.inverseSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      nurse.specialty,
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${nurse.yearsExperience} yrs exp',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),

              // Rate
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: colorScheme.surface),
          const SizedBox(height: 16),

          // ── Info grid ───────────────────────────
          Row(
            children: [
              _InfoItem(
                label: 'Availability',
                value: nurse.isAvailable ? '● Available Now' : '● Unavailable',
                valueColor:
                    nurse.isAvailable
                        ? const Color(0xFF16A34A)
                        : colorScheme.error,
              ),
              const SizedBox(width: 10),
              const _InfoItem(label: 'Service Type', value: 'Home Visit'),
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

          // ── Skills ──────────────────────────────
          if (nurse.skills.isNotEmpty) ...[
            Text(
              'SPECIALIZATIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
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
                            color: colorScheme.secondary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: colorScheme.secondary.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ],
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
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
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
                color: valueColor ?? colorScheme.inverseSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}