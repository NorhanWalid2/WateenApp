import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/admin_roles/all_doctors/presentation/cubit/all_doctors_states.dart';
import '../../data/models/all_doctors_model.dart';

class AllDoctorsCubit extends Cubit<AllDoctorsState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"), 
  );

  AllDoctorsCubit() : super(AllDoctorsInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  List<AllDoctorsModel> get _currentDoctors {
    final s = state;
    if (s is AllDoctorsLoaded) return s.doctors;
    if (s is AllDoctorsDeleteLoading) return s.doctors;
    if (s is AllDoctorsDeleteSuccess) return s.doctors;
    if (s is AllDoctorsDeleteError) return s.doctors;
    return [];
  }

  int get _currentTotal {
    final s = state;
    if (s is AllDoctorsLoaded) return s.totalCount;
    if (s is AllDoctorsDeleteLoading) return s.totalCount;
    if (s is AllDoctorsDeleteSuccess) return s.totalCount;
    if (s is AllDoctorsDeleteError) return s.totalCount;
    return 0;
  }

  // ── Fetch all doctors ─────────────────────────────────────────────
  Future<void> fetchDoctors({int pageNumber = 1, int pageSize = 100}) async {
    emit(AllDoctorsLoading());
    try {
      final response = await _dio.get(
        "/api/Appointment/Doctors",
        queryParameters: {"pageNumber": pageNumber, "pageSize": pageSize},
        options: _authOptions,
      );
      final List data = (response.data['data'] as List?) ?? [];
      final totalCount = (response.data['totalCount'] as int?) ?? 0;
      final doctors =
          data.map((e) => AllDoctorsModel.fromJson(e)).toList();
      emit(AllDoctorsLoaded(doctors, totalCount));
    } on DioException catch (e) {
      emit(AllDoctorsError(
        e.response?.data?['message'] ?? 'Failed to load doctors',
      ));
    } catch (_) {
      emit(AllDoctorsError('Something went wrong'));
    }
  }

  // ── Delete doctor account ─────────────────────────────────────────
  Future<void> deleteDoctor({required String doctorId}) async {
    final current = _currentDoctors;
    final total = _currentTotal;
    emit(AllDoctorsDeleteLoading(current, total, doctorId));
    try {
      await _dio.delete(
        "/api/Admin/delete-account",
        options: _authOptions,
        data: {"id": doctorId}, // ← fixed: was "userId", backend expects "Id"
      );
      final updated = current.where((d) => d.id != doctorId).toList();
      emit(AllDoctorsDeleteSuccess(updated, total - 1));
      emit(AllDoctorsLoaded(updated, total - 1));
    } on DioException catch (e) {
      print('DELETE ERROR: ${e.response?.statusCode} ${e.response?.data}');
      emit(AllDoctorsDeleteError(
        current,
        total,
        e.response?.data?['message'] ?? 'Failed to delete doctor',
      ));
      emit(AllDoctorsLoaded(current, total));
    } catch (_) {
      emit(AllDoctorsDeleteError(current, total, 'Something went wrong'));
      emit(AllDoctorsLoaded(current, total));
    }
  }
}