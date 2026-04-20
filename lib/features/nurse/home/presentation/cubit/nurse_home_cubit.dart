import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/nurse/home/data/models/nurse_request_model.dart';
 import 'nurse_home_state.dart';

class NurseHomeCubit extends Cubit<NurseHomeState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  NurseHomeCubit() : super(NurseHomeInitial());

  Options get _authOptions => Options(
    headers: {"Authorization": "Bearer ${AppPrefs.token}"},
  );

  List<NurseHomeRequestModel> get _currentRequests {
    final s = state;
    if (s is NurseHomeLoaded) return s.requests;
    if (s is NurseHomeActionLoading) return s.requests;
    if (s is NurseHomeActionSuccess) return s.requests;
    if (s is NurseHomeActionError) return s.requests;
    return [];
  }

  Future<void> fetchRequests() async {
    emit(NurseHomeLoading());
    try {
      final response = await _dio.get(
        "/api/HomeService/NurseRequests",
        options: _authOptions,
      );
      print('NURSE REQUESTS RAW: ${response.data}');
      final List data = response.data is List ? response.data as List : [];
      final requests =
          data.map((e) => NurseHomeRequestModel.fromJson(e)).toList();
      emit(NurseHomeLoaded(requests));
    } on DioException catch (e) {
      print('NURSE REQUESTS ERROR: ${e.response?.data}');
      emit(NurseHomeError(
        e.response?.data?['message'] ?? 'Failed to load requests',
      ));
    } catch (e) {
      emit(NurseHomeError('Something went wrong'));
    }
  }
Future<void> updateStatus({
  required String requestId,
  required bool accept,
}) async {
  final current = _currentRequests;
  emit(NurseHomeActionLoading(current, requestId));
  try {
    await _dio.put(
      "/api/HomeService/UpdateStatus/$requestId",
      queryParameters: {"accept": accept},
      options: _authOptions,
    );

    // ── Update status in list instead of removing ────────────
    final updated = current.map((r) {
      if (r.id == requestId) {
        return NurseHomeRequestModel(
          id: r.id,
          serviceDescription: r.serviceDescription,
          requestedTime: r.requestedTime,
          address: r.address,
          status: accept ? 1 : 2, // 1 = approved, 2 = rejected
          patientId: r.patientId,
          nurseId: r.nurseId,
          nurseName: r.nurseName,
          patientName: r.patientName,
        );
      }
      return r;
    }).toList();

    emit(NurseHomeActionSuccess(
      updated,
      accept ? 'Request accepted successfully' : 'Request rejected',
    ));
    emit(NurseHomeLoaded(updated));
  } on DioException catch (e) {
    print('UPDATE STATUS ERROR: ${e.response?.data}');
    emit(NurseHomeActionError(
      current,
      e.response?.data?['message'] ?? 'Action failed',
    ));
    emit(NurseHomeLoaded(current));
  } catch (e) {
    emit(NurseHomeActionError(current, 'Something went wrong'));
    emit(NurseHomeLoaded(current));
  }
}
}