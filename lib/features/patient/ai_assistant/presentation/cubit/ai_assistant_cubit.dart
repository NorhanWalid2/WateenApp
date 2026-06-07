import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/ai_assistant/data/models/diagnosis_model.dart';
import 'package:wateen_app/features/patient/ai_assistant/presentation/cubit/ai_assistant_state.dart';
 

class DiagnosisCubit extends Cubit<DiagnosisState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
  );

  DiagnosisCubit() : super(DiagnosisInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  Future<void> getDiagnosis({required String symptoms}) async {
    if (symptoms.trim().isEmpty) return;
    emit(DiagnosisLoading());
    try {
      final response = await _dio.get(
        "/api/AI/GetAiDiagnose",
        queryParameters: {"symptoms": symptoms.trim()},
        options: _authOptions,
      );
      print('DIAGNOSIS RAW: ${response.data}');
      final diagnosis = DiagnosisModel.fromJson(response.data);
      emit(DiagnosisLoaded(diagnosis, symptoms.trim()));
    } on DioException catch (e) {
      print('DIAGNOSIS ERROR: ${e.response?.data}');
      emit(DiagnosisError(
        e.response?.data?['message'] ?? 'Failed to get diagnosis',
      ));
    } catch (e) {
      print('DIAGNOSIS UNKNOWN: $e');
      emit(DiagnosisError('Something went wrong'));
    }
  }

  void reset() => emit(DiagnosisInitial());
}