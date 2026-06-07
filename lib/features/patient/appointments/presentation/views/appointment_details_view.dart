import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/core/utls/app_colors.dart';
import 'package:wateen_app/core/widgets/custom_button.dart';
import 'package:wateen_app/l10n/app_localizations.dart';
import 'package:wateen_app/core/widgets/doctor_avatar_widget.dart';
import 'package:wateen_app/features/patient/appointments/data/models/appointment_model.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/detail_row_widget.dart';
import 'package:wateen_app/features/patient/appointments/presentation/views/widgets/patient_info_row_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/features/patient/messages/data/models/conversation_model.dart';
import 'package:wateen_app/features/patient/messages/presentation/cubit/chat_cubit.dart';
import 'package:wateen_app/features/patient/messages/presentation/views/chat_view.dart';

class AppointmentDetailsView extends StatefulWidget {
  final AppointmentModel appointment;
  const AppointmentDetailsView({super.key, required this.appointment});

  @override
  State<AppointmentDetailsView> createState() =>
      _AppointmentDetailsViewState();
}

class _AppointmentDetailsViewState extends State<AppointmentDetailsView> {
  // Extra fields from GET /api/Appointment/{id}
  bool _loading = true;
  String? _doctorId;
  String? _doctorProfilePicture; // ✅ doctor photo from Cloudinary
  String? _videoCallLink;
  String? _patientName;
  String? _patientGender;
  int? _patientAge;

  @override
  void initState() {
    super.initState();
    _fetchFullDetails();
  }

  Future<void> _fetchFullDetails() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: 'https://wateen.runasp.net'));
      final r = await dio.get(
        '/api/Appointment/${widget.appointment.id}',
        options: Options(
            headers: {'Authorization': 'Bearer ${AppPrefs.token}'}),
      );
      print('APPOINTMENT DETAILS: ${r.data}');
      if (mounted) {
        setState(() {
          final data = r.data as Map<String, dynamic>;
          _doctorId = data['doctorId']?.toString();
          _doctorProfilePicture = data['doctorProfilePicture']?.toString();
          _videoCallLink = data['videoCallLink']?.toString();
          _patientName = data['patientName']?.toString();
          _patientGender = data['patientGender']?.toString();
          _patientAge = int.tryParse((data['patientAge'] ?? 0).toString());
          _loading = false;
        });
      }
    } catch (e) {
      print('APPOINTMENT DETAILS ERROR: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openVideoCall(String url) async {
    try {
      final intent = AndroidIntent(
          action: 'action_view', data: url, flags: [0x10000000]);
      await intent.launch();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    const primaryRed = Color(0xFFDC2626);
    final appt = widget.appointment;
    final isVideo = appt.type == AppointmentType.video;
    final hasVideoLink = _videoCallLink != null && _videoCallLink!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.appointmentDetails),
        centerTitle: false,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Doctor Card ──────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Row(
                      children: [
                        DoctorAvatarWidget(
                          imageUrl: _doctorProfilePicture,
                          initials: appt.avatarInitials,
                          radius: 26,
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(appt.doctorName,
                                style: textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            Text(appt.specialty,
                                style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Scheduled Appointment ────────────────────────
                  Text(l10n.scheduledAppointment,
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      children: [
                        DetailRowWidget(
                          icon: Icons.calendar_today_rounded,
                          iconColor: colorScheme.secondary,
                          label: l10n.date,
                          value: appt.date,
                        ),
                        const SizedBox(height: 12),
                        DetailRowWidget(
                          icon: Icons.access_time_rounded,
                          iconColor: Colors.orange,
                          label: l10n.time,
                          value: appt.time,
                        ),
                        const SizedBox(height: 12),
                        DetailRowWidget(
                          icon: isVideo
                              ? Icons.videocam_outlined
                              : Icons.local_hospital_outlined,
                          iconColor: Colors.blue,
                          label: 'Type',
                          value: appt.typeLabel,
                        ),
                      ],
                    ),
                  ),

                  // ── Patient Info ─────────────────────────────────
                  if (_patientName != null) ...[
                    const SizedBox(height: 20),
                    Text(l10n.patientInformation,
                        style: textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Column(
                        children: [
                          PatientInfoRowWidget(
                              label: l10n.fullName,
                              value: _patientName!),
                          if (_patientGender != null) ...[
                            const SizedBox(height: 10),
                            PatientInfoRowWidget(
                                label: l10n.gender,
                                value: _patientGender!),
                          ],
                          if (_patientAge != null && _patientAge! > 0) ...[
                            const SizedBox(height: 10),
                            PatientInfoRowWidget(
                                label: l10n.age,
                                value: '$_patientAge ${l10n.years}'),
                          ],
                          if (appt.notes != null &&
                              appt.notes!.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(l10n.problem,
                                    style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 4),
                                Text(appt.notes!,
                                    style: textTheme.bodySmall),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 50),

                  // ── Join Call (video only) ────────────────────────
                  if (isVideo && hasVideoLink) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () => _openVideoCall(_videoCallLink!),
                        icon: const Icon(Icons.videocam_rounded,
                            color: Colors.white, size: 20),
                        label: const Text('Join Call',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryRed,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ── Chat with Doctor ─────────────────────────────
                  CustomButton(
                    color: AppColorsLight.secondary,
                    colorText: AppColorsLight.background,
                    title: 'Chat with Doctor',
                    onTap: () {
                      final conversation = ConversationModel(
                        otherUserId: _doctorId ?? '',
                        doctorName: appt.doctorName,
                        specialty: appt.specialty,
                        lastMessage: '',
                        time: '',
                        unreadCount: 0,
                        initials: appt.avatarInitials,
                        color: colorScheme.secondary,
                        isOnline: false,
                        // ✅ Pass doctor profile picture so it shows in chat
                        profilePictureUrl: _doctorProfilePicture,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (_) => ChatCubit(),
                            child: ChatView(conversation: conversation),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}