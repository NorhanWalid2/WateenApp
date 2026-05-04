import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_state.dart';

class DoctorAppointmentsCubit extends Cubit<DoctorAppointmentsState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
  );

  List<DoctorAppointmentModel> _cachedAppointments = [];

  DoctorAppointmentsCubit() : super(DoctorAppointmentsInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  // ── Fetch all doctor appointments ─────────────────────────────────
  Future<void> fetchAppointments() async {
    emit(DoctorAppointmentsLoading());
    try {
      final response = await _dio.get(
        "/api/Appointment/doctor",
        options: _authOptions,
      );

      print('APPOINTMENTS RAW: ${response.data}');

      // Handle paginated { data: [...], pageNumber, totalCount }
      // or plain List, or { appointments: [...] }
      List<dynamic> data = [];
      final raw = response.data;
      if (raw is List) {
        data = raw;
      } else if (raw is Map) {
        final inner = raw['data'] ?? raw['appointments'] ?? raw['items'] ?? [];
        if (inner is List) data = inner;
      }

      print('APPOINTMENTS COUNT: ${data.length}');
      if (data.isNotEmpty) print('FIRST APPOINTMENT: ${data.first}');

      _cachedAppointments = data
          .whereType<Map>()
          .map((e) => DoctorAppointmentModel.fromJson(
                Map<String, dynamic>.from(e)))
          .toList();

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
      emit(DoctorAppointmentActionError(
          _extractMessage(e, 'Failed to respond')));
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
      emit(DoctorAppointmentActionError(
          _extractMessage(e, 'Failed to cancel')));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } catch (_) {
      emit(DoctorAppointmentActionError('Something went wrong'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    }
  }

  // ── Complete appointment ───────────────────────────────────────────
  Future<void> completeAppointment(String appointmentId) async {
    emit(DoctorAppointmentActionLoading(appointmentId));
    try {
      await _dio.put(
        "/api/Appointment/complete/$appointmentId",
        options: _authOptions,
      );
      emit(DoctorAppointmentActionSuccess('Appointment marked as complete'));
      await fetchAppointments();
    } on DioException catch (e) {
      print('COMPLETE ERROR: ${e.response?.data}');
      emit(DoctorAppointmentActionError(
          _extractMessage(e, 'Failed to complete appointment')));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } catch (_) {
      emit(DoctorAppointmentActionError('Something went wrong'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    }
  }

  /// Safely extract error message from DioException
  /// response.data can be String, Map, or null
  String _extractMessage(DioException e, String fallback) {
    final data = e.response?.data;
    if (data == null) return fallback;
    if (data is Map) return (data['message'] ?? data['title'] ?? fallback).toString();
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }
}