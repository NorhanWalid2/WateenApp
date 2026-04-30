 
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/appointments/data/models/doctor_appointment_model.dart';
import 'package:wateen_app/features/doctor_role/appointments/presentation/cubit/doctor_appointment_state.dart';
 
class DoctorAppointmentsCubit extends Cubit<DoctorAppointmentsState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  // Cache loaded appointments so action states can restore them
  List<DoctorAppointmentModel> _cachedAppointments = [];

  DoctorAppointmentsCubit() : super(DoctorAppointmentsInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  // ── Fetch all doctor appointments ──────────────────────────────────────────
  Future<void> fetchAppointments() async {
    emit(DoctorAppointmentsLoading());
    try {
      final response = await _dio.get(
        "/api/Appointment/doctor",
        options: _authOptions,
      );

      final List<dynamic> data = response.data is List
          ? response.data
          : (response.data['data'] ?? response.data['appointments'] ?? []);

      _cachedAppointments =
          data.map((e) => DoctorAppointmentModel.fromJson(e)).toList();

      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } on DioException catch (e) {
      print('APPOINTMENTS ERROR: ${e.response?.data}');
      emit(DoctorAppointmentsError(
        e.response?.data?['message'] ?? 'Failed to load appointments',
      ));
    } catch (e) {
      emit(DoctorAppointmentsError('Something went wrong'));
    }
  }

  // ── Respond to appointment (accept / decline) ──────────────────────────────
  // The API: PUT /api/Appointment/respond/{appointmentId}
  // Body: { "status": "Accepted" } or { "status": "Declined" }
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

      // Refresh list after action
      await fetchAppointments();
    } on DioException catch (e) {
      print('RESPOND ERROR: ${e.response?.data}');
      emit(DoctorAppointmentActionError(
        e.response?.data?['message'] ?? 'Failed to respond',
      ));
      // Restore previous loaded state
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } catch (_) {
      emit(DoctorAppointmentActionError('Something went wrong'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    }
  }

  // ── Cancel appointment (doctor side) ──────────────────────────────────────
  // The API: PUT /api/Appointment/doctor/cancel/{appointmentId}
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
        e.response?.data?['message'] ?? 'Failed to cancel',
      ));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } catch (_) {
      emit(DoctorAppointmentActionError('Something went wrong'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    }
  }

  // ── Mark appointment as complete ───────────────────────────────────────────
  // The API: PUT /api/Appointment/complete/{appointmentId}
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
        e.response?.data?['message'] ?? 'Failed to complete appointment',
      ));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    } catch (_) {
      emit(DoctorAppointmentActionError('Something went wrong'));
      emit(DoctorAppointmentsLoaded(_cachedAppointments));
    }
  }
}