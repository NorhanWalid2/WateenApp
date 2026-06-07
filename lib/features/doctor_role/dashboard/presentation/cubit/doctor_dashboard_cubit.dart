// lib/features/doctor_role/dashboard/presentation/cubit/doctor_dashboard_cubit.dart

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/dashboard/data/models/doctor_dashboard_model.dart';
import 'doctor_dashboard_state.dart';

class DoctorDashboardCubit extends Cubit<DoctorDashboardState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));

  DoctorDashboardCubit() : super(DoctorDashboardInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  List<dynamic> _extractList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map) {
      final inner = raw['data'] ?? raw['items'] ?? raw['appointments'] ?? [];
      if (inner is List) return inner;
    }
    return [];
  }

  int _extractTotal(dynamic raw) {
    if (raw is Map) return int.tryParse((raw['totalCount'] ?? 0).toString()) ?? 0;
    if (raw is List) return raw.length;
    return 0;
  }

  Future<void> fetchDashboard() async {
    emit(DoctorDashboardLoading());
    print('DASHBOARD: token=${AppPrefs.token?.substring(0, 20)}...');

    int totalPatients = 0;
    List<TodayAppointmentModel> todaySchedule = [];
    int todayCount = 0;
    int totalUpcoming = 0;

    // ── Request 1: Total patients ─────────────────────────────────
    // GET /api/Appointment/PatientsForDoctor
    try {
      final r = await _dio.get(
        "/api/Appointment/PatientsForDoctor",
        queryParameters: {"pageNumber": 1, "pageSize": 1},
        options: _authOptions,
      );
      print('PATIENTS RAW: ${r.data}');
      totalPatients = _extractTotal(r.data);
    } on DioException catch (e) {
      print('PATIENTS ERROR: ${e.response?.statusCode}');
    } catch (e) {
      print('PATIENTS CATCH: $e');
    }

    // ── Request 2: Today's schedule ───────────────────────────────
    // GET /api/Appointment/TodaysAppointmentsForDoctor
    try {
      final r = await _dio.get(
        "/api/Appointment/TodaysAppointmentsForDoctor",
        queryParameters: {"pageNumber": 1, "pageSize": 50},
        options: _authOptions,
      );
      print('TODAY APPTS RAW: ${r.data}');
      final data = _extractList(r.data);
      todayCount = _extractTotal(r.data);
      if (data.isNotEmpty) print('FIRST TODAY APPT: ${data.first}');
      todaySchedule = data
          .whereType<Map>()
          .map((e) => TodayAppointmentModel.fromJson(
                Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e) {
      print('TODAY APPTS ERROR: ${e.response?.statusCode}');
    } catch (e) {
      print('TODAY APPTS CATCH: $e');
    }

    // ── Request 3: Total upcoming appointments ────────────────────
    // GET /api/Appointment/UpcomingAppointmentsForDoctor
    try {
      final r = await _dio.get(
        "/api/Appointment/UpcomingAppointmentsForDoctor",
        queryParameters: {"pageNumber": 1, "pageSize": 1},
        options: _authOptions,
      );
      print('UPCOMING RAW: ${r.data}');
      totalUpcoming = _extractTotal(r.data);
    } on DioException catch (e) {
      print('UPCOMING ERROR: ${e.response?.statusCode}');
    } catch (e) {
      print('UPCOMING CATCH: $e');
    }

    if (isClosed) return;

    emit(DoctorDashboardLoaded(DoctorDashboardModel(
      totalPatients: totalPatients,
      todayAppointmentsCount: todayCount > 0 ? todayCount : todaySchedule.length,
      totalUpcoming: totalUpcoming,
      todaySchedule: todaySchedule,
    )));
  }
}