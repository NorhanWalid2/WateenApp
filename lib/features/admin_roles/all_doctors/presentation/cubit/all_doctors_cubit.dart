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
    final response = await _dio.delete(
      "/api/Admin/delete-account",
      options: Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
        contentType: 'application/json',  // ✅ ensures body is sent as JSON
      ),
      data: {"id": doctorId},
    );

    print('DELETE DOCTOR RESPONSE: ${response.statusCode}');

    final updated = current.where((d) => d.id != doctorId).toList();
    final newTotal = (total - 1).clamp(0, total);
    emit(AllDoctorsDeleteSuccess(updated, newTotal));
    emit(AllDoctorsLoaded(updated, newTotal));
  } on DioException catch (e) {
    print('DELETE DOCTOR ERROR: ${e.response?.statusCode} ${e.response?.data}');

    // ✅ safe extraction — data may be a String, Map, or null
    final rawData = e.response?.data;
    final message = rawData is Map
        ? rawData['message']?.toString() ?? 'Failed to delete doctor'
        : 'Failed to delete doctor';   // ← was crashing here on String

    emit(AllDoctorsDeleteError(current, total, message));
    emit(AllDoctorsLoaded(current, total));
  } catch (e, s) {
    print('DELETE DOCTOR UNEXPECTED: $e\n$s');
    emit(AllDoctorsDeleteError(current, total, 'Something went wrong'));
    emit(AllDoctorsLoaded(current, total));
  }
}
}