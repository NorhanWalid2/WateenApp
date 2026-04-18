import 'package:flutter/material.dart';
import '../../../data/models/book_appointment_model.dart';

class DoctorCardWidget extends StatelessWidget {
  final BookAppointmentModel doctor;
  final bool isSelected;
  final VoidCallback onTap;

  const DoctorCardWidget({
    super.key,
    required this.doctor,
    required this.isSelected,
    required this.onTap,
  });

  List<Color> _avatarGradient(ColorScheme cs) {
    final gradients = [
      [cs.secondary, cs.secondary.withOpacity(0.7)],
      [const Color(0xFFB91C1C), const Color(0xFFEF4444)],
      [const Color(0xFF991B1B), cs.secondary],
      [const Color(0xFFDC2626), const Color(0xFFFCA5A5)],
      [const Color(0xFF7F1D1D), const Color(0xFFB91C1C)],
    ];
    final index = doctor.initials.codeUnitAt(0) % gradients.length;
    return gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme   = Theme.of(context).textTheme;
    final gradient    = _avatarGradient(colorScheme);

    return GestureDetector(
      onTap: doctor.isAvailable ? onTap : null,
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
        child: Opacity(
          opacity: doctor.isAvailable ? 1.0 : 0.5,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar ──────────────────────────────────────────
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(doctor.initials,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          letterSpacing: 0.5)),
                ),
              ),

              const SizedBox(width: 14),

              // ── Info ─────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + availability
                    Row(
                      children: [
                        Expanded(
                          child: Text(doctor.name,
                              style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.inverseSurface)),
                        ),
                        if (!doctor.isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: colorScheme.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: colorScheme.error.withOpacity(0.3)),
                            ),
                            child: Text('Unavailable',
                                style: TextStyle(
                                    color: colorScheme.error,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    // Specialty
                    Text(doctor.specialty,
                        style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 8),

                    // Rating + experience
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFF59E0B), size: 15),
                        const SizedBox(width: 3),
                        Text(doctor.rating.toStringAsFixed(1),
                            style: textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.inverseSurface)),
                        Text(' (${doctor.reviewCount})',
                            style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant)),
                        const SizedBox(width: 8),
                        Container(
                            width: 3, height: 3,
                            decoration: BoxDecoration(
                                color: colorScheme.onSurfaceVariant,
                                shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text('${doctor.yearsExperience} yrs exp',
                              style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Fee
                    if (doctor.consultationFee > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('Fee  ',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500)),
                            Text('SAR ',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.secondary,
                                    fontWeight: FontWeight.w600)),
                            Text(doctor.consultationFee.toInt().toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.secondary,
                                    height: 1)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}