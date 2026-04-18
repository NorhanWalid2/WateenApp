import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';

class ProfileInfoCardWidget extends StatelessWidget {
  final PatientProfileModel profile;

  const ProfileInfoCardWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final items = <ProfileInfoItem>[
      if (profile.gender != null)
        ProfileInfoItem(
          icon: Icons.person_outline_rounded,
          label: 'Gender',
          value: profile.gender!,
        ),
      if (profile.dateOfBirth != null)
        ProfileInfoItem(
          icon: Icons.cake_outlined,
          label: 'Date of Birth',
          value: profile.dateOfBirth!.split('T').first,
        ),
      if (profile.bloodType != null)
        ProfileInfoItem(
          icon: Icons.water_drop_outlined,
          label: 'Blood Type',
          value: profile.bloodType!,
        ),
      if (profile.nationalId != null)
        ProfileInfoItem(
          icon: Icons.badge_outlined,
          label: 'National ID',
          value: profile.nationalId!,
        ),
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Info',
            style:
                textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items
                .map((item) => ProfileInfoChip(item: item))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Data model for each info chip ──────────────────────────────────────────────
class ProfileInfoItem {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

// ── Single info chip ───────────────────────────────────────────────────────────
class ProfileInfoChip extends StatelessWidget {
  final ProfileInfoItem item;

  const ProfileInfoChip({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 16, color: colorScheme.secondary),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label.toUpperCase(),
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 9,
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                item.value,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.inverseSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}