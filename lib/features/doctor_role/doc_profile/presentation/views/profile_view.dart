
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/data/models/doctor_profile_model.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/presentation/cubit/doctor_profile_cubit.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/presentation/cubit/doctor_profile_state.dart';


class DoctorProfileView extends StatefulWidget {
  const DoctorProfileView({super.key});

  @override
  State<DoctorProfileView> createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<DoctorProfileView> {
  late final DoctorProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = DoctorProfileCubit()..fetchProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _showEditSheet(DoctorProfileModel profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: _cubit,
        child: _EditProfileSheet(profile: profile),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await AppPrefs.clearAll();
              if (context.mounted) {
                context.go('/login');
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const primaryRed = Color(0xFFDC2626);

    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<DoctorProfileCubit, DoctorProfileState>(
        listener: (context, state) {
          if (state is DoctorProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ));
          } else if (state is DoctorProfileUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: colorScheme.error,
              behavior: SnackBarBehavior.floating,
            ));
          }
        },
        builder: (context, state) {
          DoctorProfileModel? profile;
          if (state is DoctorProfileLoaded) profile = state.profile;
          if (state is DoctorProfileUpdating) profile = state.profile;
          if (state is DoctorProfileUpdateSuccess) profile = state.profile;
          if (state is DoctorProfileUpdateError) profile = state.profile;

          final isLoading =
              state is DoctorProfileLoading || state is DoctorProfileUpdating;

          return Scaffold(
            backgroundColor: colorScheme.surface,
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: _cubit.fetchProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // ── Header ──────────────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                        decoration: const BoxDecoration(
                          color: primaryRed,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(28)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Profile',
                                    style: GoogleFonts.archivo(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    )),
                                if (profile != null)
                                  GestureDetector(
                                    onTap: () => _showEditSheet(profile!),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.edit_outlined,
                                              color: Colors.white, size: 16),
                                          SizedBox(width: 6),
                                          Text('Edit',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Avatar with camera button
                            isLoading
                                ? Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => _cubit.uploadProfilePicture(),
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor:
                                              Colors.white.withOpacity(0.2),
                                          backgroundImage:
                                              profile?.hasValidProfilePicture == true
                                                  ? NetworkImage(profile!.profilePictureUrl!)
                                                  : null,
                                          child: profile?.hasValidProfilePicture != true
                                              ? Text(
                                                  profile?.initials ?? 'DR',
                                                  style: const TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : null,
                                        ),
                                        // Camera badge
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Container(
                                            width: 26,
                                            height: 26,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt_rounded,
                                              size: 14,
                                              color: Color(0xFFDC2626),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                            const SizedBox(height: 12),

                            if (!isLoading && profile != null) ...[
                              Text(
                                'Dr. ${profile.fullName}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.specialization,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // ── Body ─────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: isLoading
                            ? const Center(
                                child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(
                                    color: primaryRed),
                              ))
                            : state is DoctorProfileError
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(height: 40),
                                        Icon(Icons.error_outline_rounded,
                                            size: 48,
                                            color: colorScheme.error),
                                        const SizedBox(height: 12),
                                        Text(state.message),
                                        TextButton(
                                          onPressed: _cubit.fetchProfile,
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  )
                                : profile == null
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          // Professional info
                                          _InfoCard(
                                            title: 'Professional Info',
                                            children: [
                                              _InfoRow(
                                                  icon: Icons.badge_outlined,
                                                  label: 'License',
                                                  value: profile.licenseNumber),
                                              _InfoRow(
                                                  icon: Icons.local_hospital_outlined,
                                                  label: 'Specialization',
                                                  value: profile.specialization),
                                              _InfoRow(
                                                  icon: Icons.work_outline_rounded,
                                                  label: 'Experience',
                                                  value: '${profile.experienceYears} years'),
                                              if (profile.workplace != null &&
                                                  profile.workplace!.isNotEmpty)
                                                _InfoRow(
                                                    icon: Icons.business_outlined,
                                                    label: 'Workplace',
                                                    value: profile.workplace!),
                                            ],
                                          ),

                                          const SizedBox(height: 14),

                                          // Contact info
                                          _InfoCard(
                                            title: 'Contact',
                                            children: [
                                              _InfoRow(
                                                  icon: Icons.email_outlined,
                                                  label: 'Email',
                                                  value: profile.email),
                                              _InfoRow(
                                                  icon: Icons.phone_outlined,
                                                  label: 'Phone',
                                                  value: profile.phoneNumber),
                                            ],
                                          ),

                                          // Education
                                          if (profile.education != null &&
                                              profile.education!.isNotEmpty) ...[
                                            const SizedBox(height: 14),
                                            _InfoCard(
                                              title: 'Education',
                                              children: [
                                                _InfoRow(
                                                    icon: Icons.school_outlined,
                                                    label: 'Education',
                                                    value: profile.education!),
                                              ],
                                            ),
                                          ],

                                          // Certifications
                                          if (profile.certifications != null &&
                                              profile.certifications!.isNotEmpty) ...[
                                            const SizedBox(height: 14),
                                            _InfoCard(
                                              title: 'Certifications',
                                              children: [
                                                _InfoRow(
                                                    icon: Icons.verified_outlined,
                                                    label: 'Certifications',
                                                    value: profile.certifications!),
                                              ],
                                            ),
                                          ],

                                          // Bio
                                          if (profile.bio != null &&
                                              profile.bio!.isNotEmpty) ...[
                                            const SizedBox(height: 14),
                                            _InfoCard(
                                              title: 'About',
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      bottom: 4),
                                                  child: Text(
                                                    profile.bio!,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: colorScheme
                                                          .inverseSurface,
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],

                                          const SizedBox(height: 24),

                                          // Logout
                                          SizedBox(
                                            width: double.infinity,
                                            child: OutlinedButton.icon(
                                              onPressed: _showLogoutDialog,
                                              icon: Icon(Icons.logout_rounded,
                                                  color: colorScheme.error,
                                                  size: 20),
                                              label: Text('Log Out',
                                                  style: TextStyle(
                                                      color: colorScheme.error,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              style: OutlinedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 14),
                                                side: BorderSide(
                                                    color: colorScheme.error),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12)),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 20),
                                        ],
                                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Edit Profile Sheet ────────────────────────────────────────────────────────

class _EditProfileSheet extends StatefulWidget {
  final DoctorProfileModel profile;
  const _EditProfileSheet({required this.profile});

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _educationCtrl;
  late TextEditingController _certificationsCtrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController(text: widget.profile.firstName);
    _lastNameCtrl = TextEditingController(text: widget.profile.lastName);
    _emailCtrl = TextEditingController(text: widget.profile.email);
    _educationCtrl = TextEditingController(text: widget.profile.education ?? '');
    _certificationsCtrl =
        TextEditingController(text: widget.profile.certifications ?? '');
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _educationCtrl.dispose();
    _certificationsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<DoctorProfileCubit, DoctorProfileState>(
      listener: (context, state) {
        // ✅ Only close sheet on update success, NOT on every ProfileLoaded
        // Using maybePop to avoid GoRouter "no pages left" crash
        if (state is DoctorProfileUpdateSuccess) {
          Navigator.of(context, rootNavigator: false).maybePop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(
            24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text('Edit Profile',
                  style: GoogleFonts.archivo(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.inverseSurface,
                  )),
              const SizedBox(height: 20),

              _Field(label: 'First Name', controller: _firstNameCtrl),
              const SizedBox(height: 12),
              _Field(label: 'Last Name', controller: _lastNameCtrl),
              const SizedBox(height: 12),
              _Field(
                  label: 'Email',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _Field(label: 'Education', controller: _educationCtrl),
              const SizedBox(height: 12),
              _Field(
                  label: 'Certifications',
                  controller: _certificationsCtrl,
                  maxLines: 2),
              const SizedBox(height: 24),

              BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
                builder: (context, state) {
                  final isUpdating = state is DoctorProfileUpdating;
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isUpdating
                          ? null
                          : () {
                              context
                                  .read<DoctorProfileCubit>()
                                  .updateProfile(
                                    firstName:
                                        _firstNameCtrl.text.trim(),
                                    lastName:
                                        _lastNameCtrl.text.trim(),
                                    email: _emailCtrl.text.trim(),
                                    education:
                                        _educationCtrl.text.trim(),
                                    certifications:
                                        _certificationsCtrl.text.trim(),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFFDC2626),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: isUpdating
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Save Changes',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.outlineVariant)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(
              fontSize: 14, color: colorScheme.inverseSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}

// ── Info widgets ──────────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color:
                      Theme.of(context).colorScheme.outlineVariant)),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 15, color: colorScheme.outlineVariant),
          const SizedBox(width: 8),
          Text('$label: ',
              style: TextStyle(
                  fontSize: 13, color: colorScheme.outlineVariant)),
          Expanded(
            child: Text(value,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.inverseSurface)),
          ),
        ],
      ),
    );
  }
}