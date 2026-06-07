// lib/features/doctor_role/prescriptions/presentation/cubit/prescriptions_cubit.dart

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/prescriptions/data/prescription_model.dart';
import 'package:wateen_app/features/doctor_role/prescriptions/presentation/cubit/prescription_state.dart';
 
class PrescriptionsCubit extends Cubit<PrescriptionsState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));
  final String patientId;

  PrescriptionsCubit({required this.patientId}) : super(PrescriptionsInitial());

  Options get _auth =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // Convert MM/DD/YYYY → ISO8601
  String _toIso(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        return '${parts[2]}-${parts[0].padLeft(2, '0')}-${parts[1].padLeft(2, '0')}T00:00:00';
      }
      return date;
    } catch (_) {
      return date;
    }
  }

  String _extractError(dynamic data, String fallback) {
    if (data is Map) {
      if (data['errors'] != null) {
        final errors = data['errors'] as Map;
        return errors.entries
            .map((e) => '${e.key}: ${(e.value as List).first}')
            .join(', ');
      }
      return (data['message'] ?? data['title'] ?? fallback).toString();
    }
    if (data is String && data.isNotEmpty) return data;
    return fallback;
  }

  // ── GET /api/Medication/patient/{patientId} ───────────────────────
  Future<void> fetchPrescriptions() async {
    emit(PrescriptionsLoading());
    try {
      final r = await _dio.get(
        "/api/Medication/patient/$patientId",
        options: _auth,
      );
      print('MEDICATIONS RAW: ${r.data}');
      final raw = r.data is List
          ? r.data
          : (r.data['data'] ?? r.data['items'] ?? []);
      final prescriptions = (raw as List)
          .whereType<Map>()
          .map((e) => PrescriptionModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(PrescriptionsLoaded(prescriptions));
    } on DioException catch (e) {
      print('MEDICATIONS ERROR: ${e.response?.statusCode}');
      emit(PrescriptionsError('Failed to load medications'));
    } catch (e) {
      print('MEDICATIONS CATCH: $e');
      emit(PrescriptionsError('Something went wrong'));
    }
  }

  // ── POST /api/Medication/add ──────────────────────────────────────
  Future<void> addMedication({
    required String medicationName,
    required String dosage,
    required String frequency,
    required String duration,
    required String instructions,
    required String startDate,
  }) async {
    final body = {
      "patientId": patientId,
      "name": medicationName,
      "dosage": dosage,
      "frequency": frequency,
      "duration": duration,
      "instructions": instructions,
      "startDate": _toIso(startDate),
      "isActive": true,
    };
    print('ADD MEDICATION BODY: $body');
    try {
      final r = await _dio.post(
        "/api/Medication/add",
        data: body,
        options: _auth,
      );
      print('ADD MEDICATION RESPONSE: ${r.data}');
      emit(PrescriptionActionSuccess('Medication added'));
      await fetchPrescriptions();
    } on DioException catch (e) {
      print('ADD MED ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      emit(PrescriptionsError(_extractError(e.response?.data, 'Failed to add medication')));
      await fetchPrescriptions();
    } catch (e) {
      print('ADD MED CATCH: $e');
      emit(PrescriptionsError('Something went wrong'));
    }
  }

  // ── PUT /api/Medication/update/{medicationId} ─────────────────────
  // Body: { patientId, name, dosage, frequency, duration, instructions, startDate }
  Future<void> updateMedication(
      String medicationId, Map<String, dynamic> data) async {
    print('UPDATE MEDICATION BODY: $data');
    try {
      final r = await _dio.put(
        "/api/Medication/update/$medicationId",
        data: data,
        options: _auth,
      );
      print('UPDATE MEDICATION RESPONSE: ${r.data}');
      emit(PrescriptionActionSuccess('Medication updated'));
      await fetchPrescriptions();
    } on DioException catch (e) {
      print('UPDATE MED ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      emit(PrescriptionsError(
          _extractError(e.response?.data, 'Failed to update medication')));
    } catch (e) {
      print('UPDATE MED CATCH: $e');
      emit(PrescriptionsError('Something went wrong'));
    }
  }

  // ── DELETE /api/Medication/delete/{medicationId} ──────────────────
  Future<void> deleteMedication(String medicationId) async {
    try {
      await _dio.delete(
        "/api/Medication/delete/$medicationId",
        options: _auth,
      );
      print('DELETED MEDICATION: $medicationId');
      emit(PrescriptionActionSuccess('Medication deleted'));
      await fetchPrescriptions();
    } on DioException catch (e) {
      print('DELETE MED ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      emit(PrescriptionsError('Failed to delete medication'));
    } catch (e) {
      print('DELETE MED CATCH: $e');
      emit(PrescriptionsError('Something went wrong'));
    }
  }
}