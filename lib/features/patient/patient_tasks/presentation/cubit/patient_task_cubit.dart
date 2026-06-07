import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'patient_task_state.dart';
import '../../data/models/patient_task_model.dart';
 
class PatientTaskCubit extends Cubit<PatientTaskState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));
 
  PatientTaskCubit() : super(PatientTaskInitial());
 
  Options get _auth =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});
 
  // GET /api/MedicalTask/my?isCompleted=false — pending tasks
  // GET /api/MedicalTask/my?isCompleted=true  — completed tasks
  Future<void> fetchTasks({bool isCompleted = false}) async {
    emit(PatientTaskLoading());
    try {
      final r = await _dio.get(
        "/api/MedicalTask/my",
        queryParameters: {"isCompleted": isCompleted},
        options: _auth,
      );
      print('PATIENT TASKS RAW: ${r.data}');
      final raw = r.data is List
          ? r.data
          : (r.data['data'] ?? r.data['items'] ?? []);
      final tasks = (raw as List)
          .whereType<Map>()
          .map((e) => PatientTaskModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      emit(PatientTaskLoaded(tasks, isCompleted: isCompleted));
    } on DioException catch (e) {
      print('PATIENT TASKS ERROR: ${e.response?.statusCode}');
      emit(PatientTaskError('Failed to load tasks'));
    } catch (e) {
      print('PATIENT TASKS CATCH: $e');
      emit(PatientTaskError('Something went wrong'));
    }
  }
 
  // PUT /api/MedicalTask/complete/{taskId} — patient marks task done
  Future<void> completeTask(String taskId) async {
    try {
      await _dio.put(
        "/api/MedicalTask/complete/$taskId",
        options: _auth,
      );
      print('TASK COMPLETED: $taskId');
      emit(PatientTaskActionSuccess('Task marked as complete!'));
      // Refresh pending tasks
      await fetchTasks(isCompleted: false);
    } on DioException catch (e) {
      print('COMPLETE TASK ERROR: ${e.response?.statusCode}');
      emit(PatientTaskError('Failed to complete task'));
    } catch (e) {
      print('COMPLETE TASK CATCH: $e');
      emit(PatientTaskError('Something went wrong'));
    }
  }
}