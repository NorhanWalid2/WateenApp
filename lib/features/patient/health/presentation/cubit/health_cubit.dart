import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'health_state.dart';

class HealthCubit extends Cubit<HealthState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://wateen.runasp.net",
      headers: {"Content-Type": "application/json"},
    ),
  );

  HealthCubit() : super(HealthInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // ── Fetch ──────────────────────────────────────────────────────────────────
  Future<void> fetchVitals() async {
    emit(HealthLoading());
    try {
      final response = await _dio.get(
        "/api/Profile/patientData",
        options: _authOptions,
      );
      final data = response.data as Map<String, dynamic>;
      debugPrint('=== VITALS RESPONSE: $data');

      emit(
        HealthLoaded(
          systolic: (data['systolicPressure'] ?? 0).toDouble(),
          diastolic: (data['diastolicPressure'] ?? 0).toDouble(),
          heartRate: (data['heartRate'] ?? 0).toDouble(),
          sugar: (data['sugar'] ?? 0).toDouble(),
        ),
      );
    } on DioException catch (e) {
      debugPrint('=== HEALTH FETCH ERROR: ${e.response?.data}');
      emit(HealthError('Failed to load vitals'));
    } catch (e) {
      emit(HealthError('Something went wrong'));
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────────
  Future<void> updateVitals({
    required double systolic,
    required double diastolic,
    required double heartRate,
    required double sugar,
  }) async {
    // ✅ Accept any state that has data — not just HealthLoaded
    final s = state;
    final prevLoaded =
        s is HealthLoaded
            ? s
            : HealthLoaded(
              systolic: s.systolic ?? systolic,
              diastolic: s.diastolic ?? diastolic,
              heartRate: s.heartRate ?? heartRate,
              sugar: s.sugar ?? sugar,
            );

    emit(HealthUpdating(prevLoaded));
    try {
      final profileRes = await _dio.get(
        "/api/Profile/patientData",
        options: _authOptions,
      );
      final profile = profileRes.data as Map<String, dynamic>;

      final rawGender = profile['gender'] ?? 'Male';
      final capitalizedGender =
          rawGender[0].toUpperCase() + rawGender.substring(1).toLowerCase();

      final rawDob =
          profile['dateOfBirth'] ?? DateTime.now().toUtc().toIso8601String();
      final formattedDob = rawDob.endsWith('Z') ? rawDob : '${rawDob}Z';

      final body = {
        "firstName": profile['firstName'] ?? '',
        "lastName": profile['lastName'] ?? '',
        "email": profile['email'] ?? '',
        "profilePictureUrl": profile['profilePictureUrl'] ?? '',
        "dateOfBirth": formattedDob,
        "address": profile['address'] ?? '',
        "gender": capitalizedGender,
        "systolicPressure": systolic.toInt(),
        "diastolicPressure": diastolic.toInt(),
        "heartRate": heartRate.toInt(),
        "sugar": sugar.toInt(),
      };

      debugPrint('=== UPDATE VITALS: $body');

      await _dio.put("/api/Profile/patient", data: body, options: _authOptions);

      final updated = HealthLoaded(
        systolic: systolic,
        diastolic: diastolic,
        heartRate: heartRate,
        sugar: sugar,
      );

      emit(
        HealthUpdateSuccess(
          systolic: systolic,
          diastolic: diastolic,
          heartRate: heartRate,
          sugar: sugar,
        ),
      );
      // ✅ Settle back to HealthLoaded so next update always finds data
      emit(updated);
    } on DioException catch (e) {
      debugPrint('=== VITALS UPDATE ERROR: ${e.response?.data}');
      emit(prevLoaded);
      emit(HealthError('Failed to update vitals'));
    } catch (e) {
      debugPrint('=== VITALS UNEXPECTED: $e');
      emit(prevLoaded);
      emit(HealthError('Something went wrong'));
    }
  }
}
