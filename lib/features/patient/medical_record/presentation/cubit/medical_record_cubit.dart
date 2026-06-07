// lib/features/patient/medical_records/presentation/cubit/medical_records_cubit.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/medical_record/data/models/medical_record_model.dart';
import 'package:wateen_app/features/patient/medical_record/presentation/cubit/medical_record_state.dart';
 

class MedicalRecordsCubit extends Cubit<MedicalRecordsState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));

  MedicalRecordsCubit() : super(MedicalRecordsInitial());

  Options get _auth =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  List<MedicalRecordModel> _cache = [];

  // ── GET /api/MedicalRecord/my?recordType={type} ───────────────
  // Patient views their own records — pass empty string for all
  Future<void> fetchRecords({MedicalRecordType filter = MedicalRecordType.all}) async {
    emit(MedicalRecordsLoading());
    try {
      final queryParams = filter == MedicalRecordType.all
          ? <String, dynamic>{}
          : {"recordType": MedicalRecordModel.typeToApiString(filter)};

      final r = await _dio.get(
        "/api/MedicalRecord/my",
        queryParameters: queryParams,
        options: _auth,
      );
      print('MEDICAL RECORDS RAW: ${r.data}');

      final raw = r.data is List
          ? r.data
          : (r.data['data'] ?? r.data['items'] ?? []);

      _cache = (raw as List)
          .whereType<Map>()
          .map((e) => MedicalRecordModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      emit(MedicalRecordsLoaded(_cache));
    } on DioException catch (e) {
      print('MEDICAL RECORDS ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      emit(MedicalRecordsError('Failed to load records'));
    } catch (e) {
      print('MEDICAL RECORDS CATCH: $e');
      emit(MedicalRecordsError('Something went wrong'));
    }
  }

  // ── POST /api/MedicalRecord/my-history ───────────────────────
  // API only accepts JSON — fileUrl is a string field, not a file upload
  Future<void> addMyHistory({
    required String title,
    required MedicalRecordType type,
    required DateTime date,
    String? description,
    File? file, // ignored — API does not support multipart
  }) async {
    final body = {
      "title": title,
      "recordType": MedicalRecordModel.typeToApiString(type),
      "recordDate": date.toIso8601String(),
      if (description != null && description.isNotEmpty)
        "description": description,
    };
    print('ADD HISTORY BODY: $body');
    try {
      final r = await _dio.post(
        "/api/MedicalRecord/my-history",
        data: body,
        options: Options(headers: {
          "Authorization": "Bearer ${AppPrefs.token}",
          "Content-Type": "application/json",
        }),
      );
      print('ADD HISTORY RESPONSE: ${r.data}');
      emit(MedicalRecordActionSuccess('Record added successfully'));
      await fetchRecords();
    } on DioException catch (e) {
      print('ADD HISTORY ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      final data = e.response?.data;
      String msg = 'Failed to add record';
      if (data is Map) {
        if (data['errors'] != null) {
          final errors = data['errors'] as Map;
          msg = errors.entries
              .map((e) => '${e.key}: ${(e.value as List).first}')
              .join(', ');
        } else {
          msg = (data['message'] ?? data['title'] ?? msg).toString();
        }
      }
      emit(MedicalRecordActionError(msg));
      emit(MedicalRecordsLoaded(_cache));
    } catch (e) {
      print('ADD HISTORY CATCH: $e');
      emit(MedicalRecordActionError('Something went wrong'));
      emit(MedicalRecordsLoaded(_cache));
    }
  }

  // ── DELETE /api/MedicalRecord/delete/{recordId} ───────────────
  // Both doctor and patient can delete
  Future<void> deleteRecord(String recordId) async {
    try {
      await _dio.delete(
        "/api/MedicalRecord/delete/$recordId",
        options: _auth,
      );
      print('DELETED RECORD: $recordId');
      emit(MedicalRecordActionSuccess('Record deleted'));
      await fetchRecords();
    } on DioException catch (e) {
      print('DELETE RECORD ERROR: ${e.response?.statusCode}');
      emit(MedicalRecordActionError('Failed to delete record'));
      emit(MedicalRecordsLoaded(_cache));
    } catch (e) {
      print('DELETE RECORD CATCH: $e');
      emit(MedicalRecordActionError('Something went wrong'));
      emit(MedicalRecordsLoaded(_cache));
    }
  }

  /// Detect media type from file extension
  DioMediaType _getMediaType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':  return DioMediaType('application', 'pdf');
      case 'png':  return DioMediaType('image', 'png');
      case 'jpg':
      case 'jpeg': return DioMediaType('image', 'jpeg');
      case 'gif':  return DioMediaType('image', 'gif');
      case 'webp': return DioMediaType('image', 'webp');
      case 'doc':  return DioMediaType('application', 'msword');
      case 'docx': return DioMediaType('application',
          'vnd.openxmlformats-officedocument.wordprocessingml.document');
      default:     return DioMediaType('application', 'octet-stream');
    }
  }
}