import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_state.dart';

class DoctorAppointmentsCubit extends Cubit<DoctorAppointmentsState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));
  List<DoctorAppointmentModel> _cachedAppointments = [];
  Set<String> _locallyCompleted = {};

  DoctorAppointmentsCubit() : super(DoctorAppointmentsInitial()) {
    _loadLocallyCompleted();
  }

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  // ✅ Key scoped by userId — each doctor has their own completed list
  String get _prefKey => 'completed_appointments_${AppPrefs.userId ?? "unknown"}';

  Future<void> _loadLocallyCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_prefKey) ?? [];
    _locallyCompleted = saved.toSet();
  }

  Future<void> _saveLocallyCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefKey, _locallyCompleted.toList());
  }

  // ── Fetch all doctor appointments ─────────────────────────────────
  Future<void> fetchAppointments() async {
    emit(DoctorAppointmentsLoading());
    try {
      final response = await _dio.get(
        "/api/Appointment/doctor",
        options: _authOptions,
      );

      List<dynamic> data = [];
      final raw = response.data;
      if (raw is List) {
        data = raw;
      } else if (raw is Map) {
        final inner = raw['data'] ?? raw['appointments'] ?? raw['items'] ?? [];
        if (inner is List) data = inner;
      }

      _cachedAppointments = data
          .whereType<Map>()
          .map((e) => DoctorAppointmentModel.fromJson(
                Map<String, dynamic>.from(e)))
          .toList();

      // ✅ Override status for locally completed appointments
      // Compensates for backend not persisting the status change
      _cachedAppointments = _cachedAppointments.map((a) {
        if (_locallyCompleted.contains(a.id) &&
            a.status != AppointmentStatus.completed) {
          return DoctorAppointmentModel(
            id: a.id,
            patientName: a.patientName,
            patientAge: a.patientAge,
            date: a.date,
            time: a.time,
            reason: a.reason,
            type: a.type,
            status: AppointmentStatus.completed,
            patientId: a.patientId,
          );
        }
        return a;
      }).toList();

      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } on DioException catch (e) {
      print('APPOINTMENTS ERROR: ${e.response?.data}');
      emit(DoctorAppointmentsError(
        e.response?.data?['message'] ?? 'Failed to load appointments',
      ));
    } catch (e, s) {
      print('APPOINTMENTS CATCH: $e\n$s');
      emit(DoctorAppointmentsError('Something went wrong'));
    }
  }

  // ── Respond to appointment ─────────────────────────────────────────
  Future<void> respondToAppointment({
    required String appointmentId,
    required bool accept,
  }) async {
    emit(DoctorAppointmentActionLoading(appointmentId));
    try {
      await _dio.put(
        "/api/Appointment/respond/$appointmentId",
        data: {"status": accept ? "Accepted" : "Declined"},
        options: _authOptions,
      );
      emit(DoctorAppointmentActionSuccess(
        accept ? 'Appointment accepted' : 'Appointment declined',
      ));
      await fetchAppointments();
    } on DioException catch (e) {
      print('RESPOND ERROR: ${e.response?.data}');
      emit(DoctorAppointmentActionError(_extractMessage(e, 'Failed to respond')));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } catch (_) {
      emit(DoctorAppointmentActionError('Something went wrong'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    }
  }

  // ── Cancel appointment ─────────────────────────────────────────────
  Future<void> cancelAppointment(String appointmentId) async {
    emit(DoctorAppointmentActionLoading(appointmentId));
    try {
      await _dio.put(
        "/api/Appointment/doctor/cancel/$appointmentId",
        options: _authOptions,
      );
      emit(DoctorAppointmentActionSuccess('Appointment cancelled'));
      await fetchAppointments();
    } on DioException catch (e) {
      print('CANCEL ERROR: ${e.response?.data}');
      emit(DoctorAppointmentActionError(_extractMessage(e, 'Failed to cancel')));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } catch (_) {
      emit(DoctorAppointmentActionError('Something went wrong'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    }
  }

  // ── Complete appointment ───────────────────────────────────────────
  Future<void> completeAppointment(String appointmentId) async {
    print('COMPLETE ATTEMPT: id=$appointmentId');
    emit(DoctorAppointmentActionLoading(appointmentId));
    try {
      final res = await _dio.put(
        "/api/Appointment/complete/$appointmentId",
        options: _authOptions,
      );
      print('COMPLETE RESPONSE: status=${res.statusCode} data=${res.data}');

      // ✅ Persist under this doctor's userId key
      _locallyCompleted.add(appointmentId);
      await _saveLocallyCompleted();

      _cachedAppointments = _cachedAppointments.map((a) {
        if (a.id == appointmentId) {
          return DoctorAppointmentModel(
            id: a.id,
            patientName: a.patientName,
            patientAge: a.patientAge,
            date: a.date,
            time: a.time,
            reason: a.reason,
            type: a.type,
            status: AppointmentStatus.completed,
            patientId: a.patientId,
          );
        }
        return a;
      }).toList();

      emit(DoctorAppointmentActionSuccess('Appointment marked as complete'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } on DioException catch (e) {
      print('COMPLETE ERROR: status=${e.response?.statusCode} data=${e.response?.data}');
      emit(DoctorAppointmentActionError(
          _extractMessage(e, 'Failed to complete appointment')));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } catch (e, s) {
      print('COMPLETE CATCH: $e\n$s');
      emit(DoctorAppointmentActionError('Something went wrong'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    }
  }

  String _extractMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data == null) return fallback;
    if (data is Map) return (data['message'] ?? data['title'] ?? fallback).toString();
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }
}