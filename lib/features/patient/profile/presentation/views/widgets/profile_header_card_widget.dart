import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';

class ProfileHeaderCardWidget extends StatelessWidget {
  final PatientProfileModel? profile;
  final bool isLoading;
  final VoidCallback onEditTap;

  const ProfileHeaderCardWidget({
    super.key,
    required this.profile,
    required this.isLoading,
    required this.onEditTap,
  });

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

   final hasPhoto =
    profile?.profilePictureUrl != null &&
    (profile!.profilePictureUrl!.startsWith('http://') ||
     profile!.profilePictureUrl!.startsWith('https://'));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary,
            colorScheme.secondary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // ── Avatar ──────────────────────────────────────────────
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.5),
                width: 2,
              ),
            ),
            child:
                isLoading
                    ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                    : ClipOval(
                      child:
                          hasPhoto
                              // ── Show profile photo ──────────────────
                              ? Image.network(
                                profile!.profilePictureUrl!,
                                fit: BoxFit.cover,
                                width: 64,
                                height: 64,
                                errorBuilder:
                                    (_, __, ___) => Center(
                                      child: Text(
                                        _initials(profile?.fullName),
                                        style: textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                              )
                              // ── Show initials if no photo ───────────
                              : Center(
                                child: Text(
                                  _initials(profile?.fullName),
                                  style: textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                    ),
          ),

          const SizedBox(width: 16),

          // ── Name & email ─────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading
                    ? ProfileShimmerLine(width: 140, height: 16)
                    : Text(
                      profile?.fullName ?? '',
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                const SizedBox(height: 4),
                isLoading
                    ? ProfileShimmerLine(width: 180, height: 12)
                    : Text(
                      profile?.email ?? '',
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                if (!isLoading &&
                    profile?.phoneNumber != null &&
                    profile!.phoneNumber!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    profile!.phoneNumber!,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Edit button ──────────────────────────────────────────
          if (!isLoading)
            GestureDetector(
              onTap: onEditTap,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Shimmer placeholder ────────────────────────────────────────────────────────
class ProfileShimmerLine extends StatelessWidget {
  final double width;
  final double height;

  const ProfileShimmerLine({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
