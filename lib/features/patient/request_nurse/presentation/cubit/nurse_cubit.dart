import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';
import 'nurse_state.dart';

class NurseCubit extends Cubit<NurseState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://wateen.runasp.net",
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

    debugPrint('NURSES RAW: ${response.data}');

    final body = response.data;

    final List data = body is Map
        ? (body['data'] as List? ?? [])
        : (body as List? ?? []);

    if (data.isNotEmpty) {
      debugPrint('First nurse raw: ${data.first}');
    }

    final nurses = data
        .whereType<Map>()
        .map((e) => NurseModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    debugPrint('NURSES COUNT: ${nurses.length}');

    emit(NurseLoaded(nurses));
  } on DioException catch (e) {
    emit(NurseError(_extractError(e)));
  } catch (e, s) {
    debugPrint('NURSES UNEXPECTED: $e');
    debugPrintStack(stackTrace: s);
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
      print('BOOKING DATA: nurseId=$nurseId, address=$address');
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
  print('STATUS: ${e.response?.statusCode}');
  print('RESPONSE: ${e.response?.data}');
  
  if (e.response?.data is Map) {
    return e.response?.data['message'] ??
        e.response?.data['error'] ??
        e.response?.data['errors']?.toString() ??
        'Request failed';
  }
  if (e.response?.data is String) {
    return e.response?.data;
  }
  return 'Request failed';
}
}