import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_state.dart';
import '../../data/models/pending_doctor_model.dart';
 
class DoctorAdminCubit extends Cubit<DoctorAdminState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  DoctorAdminCubit() : super(DoctorAdminInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  List<PendingDoctorModel> get _currentDoctors {
    final s = state;
    if (s is DoctorAdminLoaded) return s.doctors;
    if (s is DoctorAdminActionLoading) return s.doctors;
    if (s is DoctorAdminActionSuccess) return s.doctors;
    if (s is DoctorAdminActionError) return s.doctors;
    return [];
  }

  Future<void> fetchPendingDoctors() async {
    emit(DoctorAdminLoading());
    try {
      final response = await _dio.get(
        "/api/Admin/pending/doctors",
        options: _authOptions,
      );
      print('PENDING DOCTORS RAW: ${response.data}');
      final List data = (response.data['result'] as List?) ?? [];
      final doctors =
          data.map((e) => PendingDoctorModel.fromJson(e)).toList();
      emit(DoctorAdminLoaded(doctors));
    } on DioException catch (e) {
      print('DOCTORS ERROR: ${e.response?.data}');
      emit(DoctorAdminError(
        e.response?.data?['message'] ?? 'Failed to load doctors',
      ));
    } catch (e) {
      emit(DoctorAdminError('Something went wrong'));
    }
  }

  Future<void> acceptReject({
    required String userId,
    required bool isAccepted,
  }) async {
    final current = _currentDoctors;
    emit(DoctorAdminActionLoading(current, userId));
    try {
      await _dio.post(
        "/api/Auth/accept-reject",
        options: _authOptions,
        data: {"userId": userId, "isAccepted": isAccepted},
      );
      final updated = current.where((d) => d.id != userId).toList();
      emit(DoctorAdminActionSuccess(
        updated,
        isAccepted ? 'Doctor approved successfully' : 'Doctor rejected',
      ));
      emit(DoctorAdminLoaded(updated));
    } on DioException catch (e) {
      emit(DoctorAdminActionError(
        current,
        e.response?.data?['message'] ?? 'Action failed',
      ));
      emit(DoctorAdminLoaded(current));
    } catch (e) {
      emit(DoctorAdminActionError(current, 'Something went wrong'));
      emit(DoctorAdminLoaded(current));
    }
  }
}