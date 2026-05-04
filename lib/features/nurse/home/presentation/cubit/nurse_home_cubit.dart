import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/nurse/home/data/models/nurse_request_model.dart';
 import 'nurse_home_state.dart';

class NurseHomeCubit extends Cubit<NurseHomeState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),  
  );

  NurseHomeCubit() : super(NurseHomeInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  List<NurseHomeRequestModel> get _currentRequests {
    final s = state;
    if (s is NurseHomeLoaded) return s.requests;
    if (s is NurseHomeActionLoading) return s.requests;
    if (s is NurseHomeActionSuccess) return s.requests;
    if (s is NurseHomeActionError) return s.requests;
    return [];
  }

  // ── Fetch all requests ────────────────────────────────────────────
  Future<void> fetchRequests() async {
  emit(NurseHomeLoading());
  try {
    final response = await _dio.get(
      "/api/HomeService/NurseRequests",
      queryParameters: {"pageNumber": 1, "pageSize": 100}, // ← add pagination
      options: _authOptions,
    );
    // ← response is now {"data": [...]} not a plain list
    final List data = (response.data['data'] as List?) ?? [];
    final requests = data
        .map((e) => NurseHomeRequestModel.fromJson(e))
        .toList()
      ..sort((a, b) {
        if (a.status == 0 && b.status != 0) return -1;
        if (a.status != 0 && b.status == 0) return 1;
        return b.requestedTime.compareTo(a.requestedTime);
      });
    emit(NurseHomeLoaded(requests));
  } on DioException catch (e) {
  print('NURSE ERROR: ${e.response?.statusCode} ${e.response?.data} ${e.message}');
  emit(NurseHomeError(
    e.response?.data?['message'] ?? 'Failed to load requests',
  ));
} catch (e) {
  print('NURSE UNKNOWN ERROR: $e');
  emit(NurseHomeError('Something went wrong'));
}
}
  // ── Accept or reject a request ────────────────────────────────────
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
      final updated = current
          .map((r) => r.id != requestId ? r : r.copyWith(status: accept ? 1 : 3))
          .toList();
      emit(NurseHomeActionSuccess(
        updated,
        accept ? 'Request accepted successfully' : 'Request rejected',
      ));
      emit(NurseHomeLoaded(updated));
    } on DioException catch (e) {
      emit(NurseHomeActionError(
        current,
        e.response?.data?['message'] ?? 'Action failed',
      ));
      emit(NurseHomeLoaded(current));
    } catch (_) {
      emit(NurseHomeActionError(current, 'Something went wrong'));
      emit(NurseHomeLoaded(current));
    }
  }

  // ── Complete a visit ──────────────────────────────────────────────
  Future<void> completeRequest({required String requestId}) async {
    final current = _currentRequests;
    emit(NurseHomeActionLoading(current, requestId));
    try {
      await _dio.put(
        "/api/HomeService/CompleteRequest/$requestId",
        queryParameters: {"complete": true},
        options: _authOptions,
      );
      final updated = current
          .map((r) => r.id != requestId ? r : r.copyWith(status: 2))
          .toList();
      emit(NurseHomeActionSuccess(updated, 'Visit completed successfully'));
      emit(NurseHomeLoaded(updated));
    } on DioException catch (e) {
      emit(NurseHomeActionError(
        current,
        e.response?.data?['message'] ?? 'Failed to complete request',
      ));
      emit(NurseHomeLoaded(current));
    } catch (_) {
      emit(NurseHomeActionError(current, 'Something went wrong'));
      emit(NurseHomeLoaded(current));
    }
  }
}