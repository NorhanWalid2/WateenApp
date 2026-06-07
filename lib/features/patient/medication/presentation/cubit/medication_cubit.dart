// lib/features/patient/medications/presentation/cubit/patient_medication_cubit.dart

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/medication/presentation/cubit/medication_state.dart';
import '../../data/models/patient_medication_model.dart';

class PatientMedicationCubit extends Cubit<PatientMedicationState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));

  PatientMedicationCubit() : super(PatientMedicationInitial());

  Options get _auth =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // GET /api/Medication/my?isActive=true  — patient sees active meds
  // GET /api/Medication/my?isActive=false — patient sees past meds
  Future<void> fetchMedications({bool activeOnly = true}) async {
    emit(PatientMedicationLoading());
    try {
      final r = await _dio.get(
        "/api/Medication/my",
        queryParameters: {"isActive": activeOnly},
        options: _auth,
      );
      print('PATIENT MEDS RAW: ${r.data}');
      final raw = r.data is List
          ? r.data
          : (r.data['data'] ?? r.data['items'] ?? []);
      final meds = (raw as List)
          .whereType<Map>()
          .map((e) => PatientMedicationModel.fromJson(
                Map<String, dynamic>.from(e)))
          .toList();
      emit(PatientMedicationLoaded(meds, activeOnly: activeOnly));
    } on DioException catch (e) {
      print('PATIENT MEDS ERROR: ${e.response?.statusCode}');
      emit(PatientMedicationError('Failed to load medications'));
    } catch (e) {
      print('PATIENT MEDS CATCH: $e');
      emit(PatientMedicationError('Something went wrong'));
    }
  }
}