import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/data/models/pending_doctor_model.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_cubit.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_state.dart';
 

class PendingDoctorCardWidget extends StatelessWidget {
  final PendingDoctorModel doctor;

  const PendingDoctorCardWidget({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<DoctorAdminCubit, DoctorAdminState>(
      builder: (context, state) {
        final isActing = state is DoctorAdminActionLoading &&
            state.userId == doctor.id;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        doctor.initials,
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.fullName,
                          style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          doctor.email,
                          style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Doctor',
                      style: TextStyle(
                        color: colorScheme.secondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: colorScheme.outline.withOpacity(0.2)),
              const SizedBox(height: 12),

              // ── Details ──────────────────────────────────────
              DoctorDetailRowWidget(
                icon: Icons.local_hospital_outlined,
                label: 'Work Place',
                value: doctor.workPlace,
              ),
              const SizedBox(height: 6),
              DoctorDetailRowWidget(
                icon: Icons.badge_outlined,
                label: 'License',
                value: doctor.licenseNumber,
              ),
              const SizedBox(height: 6),
              DoctorDetailRowWidget(
                icon: Icons.work_outline_rounded,
                label: 'Experience',
                value: '${doctor.experienceYears} years',
              ),
              const SizedBox(height: 6),
              DoctorDetailRowWidget(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: doctor.phone,
              ),

              const SizedBox(height: 16),

              // ── Actions ──────────────────────────────────────
              isActing
                  ? Center(
                      child: CircularProgressIndicator(
                          color: colorScheme.secondary, strokeWidth: 2),
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                context.read<DoctorAdminCubit>().acceptReject(
                                      userId: doctor.id,
                                      isAccepted: false,
                                    ),
                            icon: Icon(Icons.close_rounded,
                                size: 16, color: colorScheme.error),
                            label: Text('Reject',
                                style: TextStyle(color: colorScheme.error)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colorScheme.error),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                context.read<DoctorAdminCubit>().acceptReject(
                                      userId: doctor.id,
                                      isAccepted: true,
                                    ),
                            icon: const Icon(Icons.check_rounded,
                                size: 16, color: Colors.white),
                            label: const Text('Approve',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF16A34A),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
}

class DoctorDetailRowWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const DoctorDetailRowWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: textTheme.bodySmall
              ?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.inverseSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}