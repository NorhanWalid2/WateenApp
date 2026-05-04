import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/admin_roles/doctors_management/presentation/cubit/admin_doctor_management_state.dart';
import '../../data/models/pending_doctor_model.dart';

class DoctorAdminCubit extends Cubit<DoctorAdminState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
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

      final body = response.data;

      final List data = body is Map
          ? ((body['result'] ?? body['data']) as List? ?? [])
          : (body as List? ?? []);

      final doctors = data
          .whereType<Map>()
          .map(
            (e) => PendingDoctorModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();

      print('PENDING DOCTORS COUNT: ${doctors.length}');

      emit(DoctorAdminLoaded(doctors));
    } on DioException catch (e) {
      print('DOCTORS ERROR: ${e.response?.data}');

      final data = e.response?.data;
      final message = data is Map
          ? data['message']?.toString() ?? 'Failed to load doctors'
          : 'Failed to load doctors';

      emit(DoctorAdminError(message));
    } catch (e, s) {
      print('DOCTORS UNEXPECTED ERROR: $e');
      print(s);
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
        "/api/Admin/accept-reject",
        options: _authOptions,
        data: {
          "userId": userId,
          "isAccepted": isAccepted,
        },
      );

      final updated = current.where((d) => d.id != userId).toList();

      emit(
        DoctorAdminActionSuccess(
          updated,
          isAccepted
              ? 'Doctor approved successfully'
              : 'Doctor rejected',
        ),
      );

      emit(DoctorAdminLoaded(updated));
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map
          ? data['message']?.toString() ?? 'Action failed'
          : 'Action failed';

      emit(DoctorAdminActionError(current, message));
      emit(DoctorAdminLoaded(current));
    } catch (e, s) {
      print('DOCTOR ACTION ERROR: $e');
      print(s);
      emit(DoctorAdminActionError(current, 'Something went wrong'));
      emit(DoctorAdminLoaded(current));
    }
  }
}