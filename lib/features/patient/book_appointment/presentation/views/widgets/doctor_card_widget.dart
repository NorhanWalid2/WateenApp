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

  // Give each doctor a unique gradient based on initials
  List<Color> _avatarGradient() {
    final gradients = [
      [const Color(0xFF0D9488), const Color(0xFF14B8A6)], // teal
      [const Color(0xFF3B82F6), const Color(0xFF6366F1)], // blue
      [const Color(0xFFEC4899), const Color(0xFFF43F5E)], // pink
      [const Color(0xFFF59E0B), const Color(0xFFF97316)], // amber
      [const Color(0xFF8B5CF6), const Color(0xFF6366F1)], // violet
    ];
    final index = doctor.initials.codeUnitAt(0) % gradients.length;
    return gradients[index];
  }

  @override
  Widget build(BuildContext context) {
    final gradient = _avatarGradient();

    return GestureDetector(
      onTap: doctor.isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.transparent,
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
          opacity: doctor.isAvailable ? 1.0 : 0.6,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar ──
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
                    doctor.initials,
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

              // ── Info ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + unavailable badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                        ),
                        if (!doctor.isAvailable)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF2F2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFCA5A5),
                              ),
                            ),
                            child: const Text(
                              'Not Available',
                              style: TextStyle(
                                color: Color(0xFFEF4444),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 2),

                    // Specialty
                    Text(
                      doctor.specialty,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Rating + experience
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF59E0B),
                          size: 15,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          doctor.rating.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                        Text(
                          ' (${doctor.reviewCount})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outlineVariant,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${doctor.yearsExperience} yrs exp',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color:
                                  Theme.of(context).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Fee box
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Fee  ',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Text(
                            'SAR ',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF0D9488),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            doctor.consultationFee.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D9488),
                              height: 1,
                            ),
                          ),
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
