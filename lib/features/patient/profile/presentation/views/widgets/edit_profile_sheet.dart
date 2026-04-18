import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';
import 'package:wateen_app/features/patient/profile/presentation/cubit/profile_cubit.dart';
import 'package:wateen_app/features/patient/profile/presentation/cubit/profile_state.dart';
import 'profile_sheet_field_widget.dart';

class EditProfileSheet extends StatefulWidget {
  final PatientProfileModel profile;
  final ProfileCubit cubit;

  const EditProfileSheet({
    super.key,
    required this.profile,
    required this.cubit,
  });

  @override
  State<EditProfileSheet> createState() => EditProfileSheetState();
}

class EditProfileSheetState extends State<EditProfileSheet> {
  late final TextEditingController firstNameCtrl;
  late final TextEditingController lastNameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController addressCtrl;
  late final TextEditingController dobCtrl;
  late String selectedGender;

  File? _pickedImage;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    firstNameCtrl = TextEditingController(text: widget.profile.firstName);
    lastNameCtrl  = TextEditingController(text: widget.profile.lastName);
    emailCtrl     = TextEditingController(text: widget.profile.email);
    addressCtrl   = TextEditingController(text: widget.profile.address ?? '');
    final rawDob  = widget.profile.dateOfBirth ?? '';
    dobCtrl       = TextEditingController(
      text: rawDob.isNotEmpty ? rawDob.split('T').first : '',
    );
    selectedGender = widget.profile.gender ?? 'male';
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    dobCtrl.dispose();
    super.dispose();
  }

  // ── Image Picker ───────────────────────────────────────────────────────────
  Future<void> pickImage(ImageSource source) async {
    setState(() => _isPickingImage = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 512,
        maxHeight: 512,
      );
      if (picked != null) {
        setState(() => _pickedImage = File(picked.path));
      }
    } catch (_) {
    } finally {
      setState(() => _isPickingImage = false);
    }
  }

  void showImageSourceSheet() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Choose Photo',
                style:
                    textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.camera);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: colorScheme.outline.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.camera_alt_rounded,
                              color: colorScheme.secondary, size: 28),
                          const SizedBox(height: 8),
                          Text('Camera',
                              style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage(ImageSource.gallery);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: colorScheme.outline.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.photo_library_rounded,
                              color: colorScheme.secondary, size: 28),
                          const SizedBox(height: 8),
                          Text('Gallery',
                              style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_pickedImage != null)
              TextButton.icon(
                onPressed: () {
                  setState(() => _pickedImage = null);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.delete_outline_rounded,
                    color: colorScheme.error, size: 18),
                label: Text('Remove Photo',
                    style: TextStyle(color: colorScheme.error)),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> pickDob() async {
    DateTime initial = DateTime(2000);
    try {
      if (dobCtrl.text.isNotEmpty) initial = DateTime.parse(dobCtrl.text);
    } catch (_) {}

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context)
              .colorScheme
              .copyWith(primary: Theme.of(context).colorScheme.secondary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        dobCtrl.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  // ── Convert image to base64 ────────────────────────────────────────────────
  Future<String?> _imageToBase64() async {
    if (_pickedImage == null) return null;
    final bytes = await _pickedImage!.readAsBytes();
    return 'data:image/jpeg;base64,${base64Encode(bytes)}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) Navigator.pop(context);
        },
        builder: (context, state) {
          final isUpdating = state is ProfileUpdating;

          return Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Handle ────────────────────────────────────────
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.outline.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Title ─────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.edit_rounded,
                            color: colorScheme.secondary, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text('Edit Profile',
                          style: textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Avatar Picker ─────────────────────────────────
                  Center(
                    child: GestureDetector(
                      onTap: showImageSourceSheet,
                      child: Stack(
                        children: [
                          // Avatar circle
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.secondary.withOpacity(0.15),
                              border: Border.all(
                                  color: colorScheme.secondary, width: 2),
                              image: _pickedImage != null
                                  ? DecorationImage(
                                      image: FileImage(_pickedImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : (widget.profile.profilePictureUrl != null &&
                                          widget.profile.profilePictureUrl!
                                              .isNotEmpty)
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              widget.profile.profilePictureUrl!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                            ),
                            child: (_pickedImage == null &&
                                    (widget.profile.profilePictureUrl == null ||
                                        widget.profile.profilePictureUrl!
                                            .isEmpty))
                                ? Icon(Icons.person_rounded,
                                    size: 40,
                                    color: colorScheme.secondary)
                                : null,
                          ),
                          // Camera badge
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: colorScheme.secondary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: colorScheme.primary, width: 2),
                              ),
                              child: _isPickingImage
                                  ? const Padding(
                                      padding: EdgeInsets.all(6),
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Icon(Icons.camera_alt_rounded,
                                      color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Tap to change photo',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Error banner ──────────────────────────────────
                  if (state is ProfileUpdateError) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: colorScheme.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline_rounded,
                              color: colorScheme.error, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(state.message,
                                style: textTheme.bodySmall
                                    ?.copyWith(color: colorScheme.error)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ── First & Last Name ─────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: ProfileSheetFieldWidget(
                          label: 'First Name',
                          controller: firstNameCtrl,
                          icon: Icons.person_outline_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ProfileSheetFieldWidget(
                          label: 'Last Name',
                          controller: lastNameCtrl,
                          icon: Icons.person_outline_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Email ─────────────────────────────────────────
                  ProfileSheetFieldWidget(
                    label: 'Email',
                    controller: emailCtrl,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  // ── Date of Birth ─────────────────────────────────
                  GestureDetector(
                    onTap: pickDob,
                    child: AbsorbPointer(
                      child: ProfileSheetFieldWidget(
                        label: 'Date of Birth',
                        controller: dobCtrl,
                        icon: Icons.cake_outlined,
                        hint: 'Tap to select',
                        trailing: Icon(Icons.calendar_today_rounded,
                            size: 16, color: colorScheme.secondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ── Gender ────────────────────────────────────────
                  Text(
                    'GENDER',
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['male', 'female'].map((g) {
                      final isSelected = selectedGender.toLowerCase() == g;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedGender = g),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin:
                                EdgeInsets.only(right: g == 'male' ? 8 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.secondary
                                  : colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? colorScheme.secondary
                                    : colorScheme.outline.withOpacity(0.4),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  g == 'male'
                                      ? Icons.male_rounded
                                      : Icons.female_rounded,
                                  color: isSelected
                                      ? Colors.white
                                      : colorScheme.onSurfaceVariant,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  g == 'male' ? 'Male' : 'Female',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // ── Address ───────────────────────────────────────
                  ProfileSheetFieldWidget(
                    label: 'Address',
                    controller: addressCtrl,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 28),

                  // ── Save Button ───────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              final base64Image = await _imageToBase64();
                              widget.cubit.updatePatientProfile(
                                firstName: firstNameCtrl.text.trim(),
                                lastName: lastNameCtrl.text.trim(),
                                email: emailCtrl.text.trim(),
                                address: addressCtrl.text.trim(),
                                dateOfBirth: dobCtrl.text.trim(),
                                gender: selectedGender,
                                profilePictureUrl: base64Image,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.secondary,
                        disabledBackgroundColor:
                            colorScheme.outline.withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: isUpdating
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2.5),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Save Changes',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}