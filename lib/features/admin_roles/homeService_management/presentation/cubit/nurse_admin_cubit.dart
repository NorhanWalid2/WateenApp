import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import '../../data/models/pending_nurse_model.dart';
import 'nurse_admin_state.dart';

class NurseAdminCubit extends Cubit<NurseAdminState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  NurseAdminCubit() : super(NurseAdminInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  List<PendingNurseModel> get _currentNurses {
    final s = state;
    if (s is NurseAdminLoaded) return s.nurses;
    if (s is NurseAdminActionLoading) return s.nurses;
    if (s is NurseAdminActionSuccess) return s.nurses;
    if (s is NurseAdminActionError) return s.nurses;
    return [];
  }

  Future<void> fetchPendingNurses() async {
    emit(NurseAdminLoading());
    try {
      final response = await _dio.get(
        "/api/Admin/pending/nurses",
        options: _authOptions,
      );
      print('PENDING NURSES RAW: ${response.data}');
      final List data = (response.data['result'] as List?) ?? [];
      final nurses =
          data.map((e) => PendingNurseModel.fromJson(e)).toList();
      emit(NurseAdminLoaded(nurses));
    } on DioException catch (e) {
      print('NURSES ERROR: ${e.response?.data}');
      emit(NurseAdminError(
        e.response?.data?['message'] ?? 'Failed to load nurses',
      ));
    } catch (e) {
      emit(NurseAdminError('Something went wrong'));
    }
  }

  Future<void> acceptReject({
    required String userId,
    required bool isAccepted,
  }) async {
    final current = _currentNurses;
    emit(NurseAdminActionLoading(current, userId));
    try {
      await _dio.post(
        "/api/Auth/accept-reject",
        options: _authOptions,
        data: {"userId": userId, "isAccepted": isAccepted},
      );
      final updated = current.where((n) => n.id != userId).toList();
      emit(NurseAdminActionSuccess(
        updated,
        isAccepted ? 'Nurse approved successfully' : 'Nurse rejected',
      ));
      emit(NurseAdminLoaded(updated));
    } on DioException catch (e) {
      emit(NurseAdminActionError(
        current,
        e.response?.data?['message'] ?? 'Action failed',
      ));
      emit(NurseAdminLoaded(current));
    } catch (e) {
      emit(NurseAdminActionError(current, 'Something went wrong'));
      emit(NurseAdminLoaded(current));
    }
  }
}