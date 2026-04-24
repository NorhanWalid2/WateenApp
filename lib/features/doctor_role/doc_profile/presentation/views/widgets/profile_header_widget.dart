import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/data/models/doctor_profile_model.dart';

class DoctorProfileHeaderWidget extends StatelessWidget {
  final DoctorProfileModel profile;
  final VoidCallback onEdit;

  const DoctorProfileHeaderWidget({
    super.key,
    required this.profile,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Avatar + Edit ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    profile.initial,
                    style: GoogleFonts.archivo(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit_rounded,
                          color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Name ──
          Text(
            profile.name,
            style: GoogleFonts.archivo(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 4),

          // ── Specialty ──
          Text(
            profile.specialty,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
            ),
          ),

          const SizedBox(height: 10),

          // ── Rating + Experience ──
          Row(
            children: [
              const Icon(Icons.star_rounded,
                  color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                '${profile.rating} (${profile.reviewCount} reviews)',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${profile.yearsExperience} years experience',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}