// lib/features/doctor_role/checklist/presentation/cubit/checklist_cubit.dart

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/checklist/data/models/checklist_model.dart';
import 'checklist_state.dart';

class ChecklistCubit extends Cubit<ChecklistState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));
  final String patientId;

  ChecklistCubit({required this.patientId}) : super(ChecklistInitial());

  Options get _auth =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // GET /api/MedicalTask/patient/{patientId}  — Doctor views patient tasks
  Future<void> fetchTasks() async {
    emit(ChecklistLoading());
    try {
      final r = await _dio.get(
        "/api/MedicalTask/patient/$patientId",
        options: _auth,
      );
      print('TASKS RAW: ${r.data}');
      final raw = r.data is List ? r.data : (r.data['data'] ?? r.data['items'] ?? []);
      final tasks = (raw as List)
          .whereType<Map>()
          .map((e) => ChecklistTaskModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(ChecklistLoaded(tasks));
    } on DioException catch (e) {
      print('TASKS ERROR: ${e.response?.statusCode}');
      emit(ChecklistError('Failed to load tasks'));
    } catch (e) {
      print('TASKS CATCH: $e');
      emit(ChecklistError('Something went wrong'));
    }
  }

  // POST /api/MedicalTask/add  — Doctor adds task for patient
  // API requires: TaskTitle, TaskDescription, DueDate, Priority (High/Medium/Low),
  //               Category (Test/Appointment/Medication/Other), PatientId
  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required String priority,
    required String category,
  }) async {
    // Map enum names to API-expected values
    String mapCategory(String c) {
      final lower = c.toLowerCase();
      if (lower.contains('follow')) return 'Other'; // followUp → Other
      if (lower == 'test') return 'Test';
      if (lower == 'appointment') return 'Appointment';
      if (lower == 'medication') return 'Medication';
      return 'Other';
    }

    String mapPriority(String p) {
      final lower = p.toLowerCase();
      if (lower == 'high') return 'High';
      if (lower == 'low') return 'Low';
      return 'Medium';
    }

    final body = {
      "patientId": patientId,
      "taskTitle": title,           // ✅ TaskTitle not title
      "taskDescription": description, // ✅ TaskDescription not description
      "dueDate": dueDate.toIso8601String(),
      "priority": mapPriority(priority),   // ✅ High/Medium/Low exactly
      "category": mapCategory(category),   // ✅ Test/Appointment/Medication/Other
    };
    print('ADD TASK BODY: $body');

    try {
      final r = await _dio.post(
        "/api/MedicalTask/add",
        data: body,
        options: _auth,
      );
      print('ADD TASK RESPONSE: ${r.data}');
      emit(ChecklistActionSuccess('Task added'));
      await fetchTasks();
    } on DioException catch (e) {
      print('ADD TASK ERROR: ${e.response?.data}');
      final data = e.response?.data;
      String msg = 'Failed to add task';
      if (data is Map) {
        msg = (data['message'] ?? data['title'] ?? msg).toString();
        if (data['errors'] != null) print('VALIDATION: ${data['errors']}');
      }
      emit(ChecklistError(msg));
    } catch (e) {
      print('ADD TASK CATCH: $e');
      emit(ChecklistError('Something went wrong'));
    }
  }


  // DELETE /api/MedicalTask/delete/{taskId}  — Doctor deletes task
  Future<void> deleteTask(String taskId) async {
    try {
      await _dio.delete(
        "/api/MedicalTask/delete/$taskId",
        options: _auth,
      );
      emit(ChecklistActionSuccess('Task deleted'));
      await fetchTasks();
    } on DioException catch (e) {
      print('DELETE TASK ERROR: ${e.response?.data}');
      emit(ChecklistError('Failed to delete task'));
    } catch (e) {
      emit(ChecklistError('Something went wrong'));
    }
  }
}