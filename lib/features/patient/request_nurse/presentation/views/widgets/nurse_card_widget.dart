import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';

class NurseCardWidget extends StatelessWidget {
  final NurseModel nurse;
  final bool isSelected;
  final VoidCallback onTap;

  const NurseCardWidget({
    super.key,
    required this.nurse,
    required this.isSelected,
    required this.onTap,
  });

  // Avatar uses shades of the brand red
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
    final visibleSkills = nurse.skills.take(2).toList();
    final remainingCount = nurse.skills.length - 2;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? colorScheme.secondary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar ─────────────────────────────
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  nurse.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ── Info ────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + availability badge
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          nurse.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              nurse.isAvailable
                                  ? const Color(0xFF16A34A).withOpacity(0.1)
                                  : colorScheme.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          nurse.isAvailable ? '● Available' : '● Busy',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color:
                                nurse.isAvailable
                                    ? const Color(0xFF16A34A)
                                    : colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),
                  Text(
                    nurse.specialty,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating + experience
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${nurse.yearsExperience} yrs exp',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Skill tags
                  if (nurse.skills.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        ...visibleSkills.map(
                          (skill) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
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
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.secondary,
                              ),
                            ),
                          ),
                        ),
                        if (remainingCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: colorScheme.outlineVariant,
                              ),
                            ),
                            child: Text(
                              '+$remainingCount',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                      ],
                    ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
