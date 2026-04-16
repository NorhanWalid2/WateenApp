import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';
import 'nurse_state.dart';

class NurseCubit extends Cubit<NurseState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://wateen.runasp.net",
      headers: {"Content-Type": "application/json"},
    ),
  );

  NurseCubit() : super(NurseInitial());

  // ── Fetch all nurses ───────────────────────────────────────────────────────
  Future<void> fetchNurses() async {
    emit(NurseLoading());
    try {
      final token = AppPrefs.token;
      final response = await _dio.get(
        "/api/HomeService/Nurses",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      final List data = response.data as List;
      final nurses = data.map((e) => NurseModel.fromJson(e)).toList();
      emit(NurseLoaded(nurses));
    } on DioException catch (e) {
      emit(NurseError(_extractError(e)));
    } catch (_) {
      emit(NurseError('Something went wrong'));
    }
  }

  // ── Book a nurse ───────────────────────────────────────────────────────────
  Future<void> bookNurse({
    required String nurseId,
    required String address,
    required String serviceDescription,
    required DateTime requestedTime,
  }) async {
    emit(NurseBookingLoading());
    try {
      final token = AppPrefs.token;
      await _dio.post(
        "/api/HomeService/book",
        options: Options(headers: {"Authorization": "Bearer $token"}),
        data: {
          "nurseId": nurseId,
          "address": address,
          "serviceDescription": serviceDescription,
          "requestedTime": requestedTime.toUtc().toIso8601String(),
        },
      );
      emit(NurseBookingSuccess());
    } on DioException catch (e) {
      emit(NurseBookingError(_extractError(e)));
    } catch (_) {
      emit(NurseBookingError('Something went wrong'));
    }
  }

  // ── Helper ─────────────────────────────────────────────────────────────────
  String _extractError(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ??
          e.response?.data['error'] ??
          e.response?.data['errors']?.toString() ??
          'Request failed';
    }
    return 'Request failed';
  }
}