import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wateen_app/features/nurse/layout/widgets/nurse_top_bar_widget.dart';
import '../../data/models/nurse_profile_model.dart';
import '../cubit/nurse_profile_cubit.dart';
import '../cubit/nurse_profile_state.dart';

class NurseProfileView extends StatelessWidget {
  final VoidCallback onMenuTap;

  const NurseProfileView({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NurseProfileCubit()..fetchProfile(),
      child: NurseProfileBody(onMenuTap: onMenuTap),
    );
  }
}

class NurseProfileBody extends StatelessWidget {
  final VoidCallback onMenuTap;

  const NurseProfileBody({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            NurseTopBarWidget(onMenuTap: onMenuTap),
            Expanded(
              child: BlocConsumer<NurseProfileCubit, NurseProfileState>(
                listener: (context, state) {
                  if (state is NurseProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: colorScheme.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is NurseProfileLoading ||
                      state is NurseProfileInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is NurseProfileError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry:
                          () =>
                              context.read<NurseProfileCubit>().fetchProfile(),
                    );
                  }

                  final profile =
                      state is NurseProfileLoaded
                          ? state.profile
                          : state is NurseProfileUpdating
                          ? state.profile
                          : state is NurseProfileUpdated
                          ? state.profile
                          : null;

                  if (profile == null) return const SizedBox();

                  final isUpdating = state is NurseProfileUpdating;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _ProfileHeaderCard(
                          profile: profile,
                          isUpdating: isUpdating,
                          onEdit: () => _showEditProfileSheet(context, profile),
                          onImageTap: () async {
                            final picker = ImagePicker();

                            final picked = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 80,
                            );

                            if (picked == null) return;

                            context
                                .read<NurseProfileCubit>()
                                .updateProfilePicture(File(picked.path));
                          },
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: 'Personal Information',
                          children: [
                            _InfoRow(
                              icon: Icons.person_outline_rounded,
                              label: 'Name',
                              value: profile.fullName,
                            ),
                            _InfoRow(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: profile.email,
                            ),
                            _InfoRow(
                              icon: Icons.phone_outlined,
                              label: 'Phone',
                              value: profile.phoneNumber,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: 'Nurse Details',
                          children: [
                            _InfoRow(
                              icon: Icons.medical_services_outlined,
                              label: 'Specialization',
                              value: profile.specialization,
                            ),
                            _InfoRow(
                              icon: Icons.confirmation_number_outlined,
                              label: 'License Number',
                              value: profile.licenseNumber,
                            ),
                            _InfoRow(
                              icon: Icons.timeline_rounded,
                              label: 'Experience',
                              value: '${profile.experienceYears} years',
                            ),
                            _InfoRow(
                              icon: Icons.task_alt_rounded,
                              label: 'Completed Requests',
                              value: '${profile.completedRequests}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _StatusCard(profile: profile),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileSheet(BuildContext context, NurseProfileModel profile) {
    final cubit = context.read<NurseProfileCubit>();

    final firstNameController = TextEditingController(text: profile.firstName);
    final lastNameController = TextEditingController(text: profile.lastName);
    final phoneController = TextEditingController(text: profile.phoneNumber);
    final specializationController = TextEditingController(
      text: profile.specialization,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.82,
          minChildSize: 0.45,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.fromLTRB(
                  20,
                  14,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.outline,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Edit Profile',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 22),

                    _EditField(
                      controller: firstNameController,
                      label: 'First Name',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 14),

                    _EditField(
                      controller: lastNameController,
                      label: 'Last Name',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 14),

                    _EditField(
                      controller: phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),

                    _EditField(
                      controller: specializationController,
                      label: 'Specialization',
                      icon: Icons.medical_services_outlined,
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);

                          cubit.updateProfile(
                            oldProfile: profile,
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            phoneNumber: phoneController.text.trim(),
                            specialization:
                                specializationController.text.trim(),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  final NurseProfileModel profile;
  final bool isUpdating;
  final VoidCallback onEdit;
  final VoidCallback onImageTap;

  const _ProfileHeaderCard({
    required this.profile,
    required this.isUpdating,
    required this.onEdit,
    required this.onImageTap,
  });

  bool _isValidUrl(String url) {
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.secondary,
            colorScheme.secondary.withOpacity(0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: isUpdating ? null : onImageTap,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white.withOpacity(0.22),
                      backgroundImage:
                          _isValidUrl(profile.profilePictureUrl)
                              ? NetworkImage(profile.profilePictureUrl)
                              : null,
                      child:
                          !_isValidUrl(profile.profilePictureUrl)
                              ? Text(
                                profile.initials,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              )
                              : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 14,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.specialization,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.88),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: isUpdating ? null : onEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child:
                      isUpdating
                          ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Row(
                            children: [
                              Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _MiniStat(
                label: 'Experience',
                value: '${profile.experienceYears}y',
              ),
              _MiniStat(label: 'Visits', value: '${profile.completedRequests}'),
              _MiniStat(
                label: 'Status',
                value: profile.isActive ? 'Active' : 'Inactive',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;

  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.78),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
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

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: colorScheme.secondary, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? 'Not available' : value,
                  style: TextStyle(
                    color: colorScheme.inverseSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final NurseProfileModel profile;

  const _StatusCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final color =
        profile.isActive
            ? const Color(0xFF16A34A)
            : Theme.of(context).colorScheme.error;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(
            profile.isActive
                ? Icons.check_circle_rounded
                : Icons.cancel_rounded,
            color: color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              profile.isActive
                  ? 'Your nurse account is active and visible to patients.'
                  : 'Your nurse account is currently inactive.',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;

  const _EditField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        prefixIcon: Icon(icon, color: colorScheme.secondary),
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(message),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
