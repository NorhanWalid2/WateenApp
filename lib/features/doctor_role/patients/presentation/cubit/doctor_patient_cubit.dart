// lib/features/doctor_role/patients/presentation/cubit/doctor_patients_cubit.dart

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/patients/data/models/patient_model.dart';
import 'package:wateen_app/features/doctor_role/patients/presentation/cubit/doctor_patient_state.dart';


// ── Cubits ────────────────────────────────────────────────────────────────────

class DoctorPatientsCubit extends Cubit<DoctorPatientsState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));

  DoctorPatientsCubit() : super(DoctorPatientsInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  Future<void> fetchPatients() async {
    emit(DoctorPatientsLoading());
    try {
      // Fetch all pages
      final r = await _dio.get(
        "/api/Appointment/PatientsForDoctor",
        queryParameters: {"pageNumber": 1, "pageSize": 100},
        options: _authOptions,
      );
      print('PATIENTS LIST RAW: ${r.data}');
      final raw = r.data;
      List<dynamic> data = [];
      if (raw is List) data = raw;
      else if (raw is Map) data = raw['data'] ?? raw['items'] ?? [];

      final patients = data
          .whereType<Map>()
          .map((e) => PatientModel.fromListJson(Map<String, dynamic>.from(e)))
          .toList();

      emit(DoctorPatientsLoaded(patients));
    } on DioException catch (e) {
      print('PATIENTS LIST ERROR: ${e.response?.statusCode}');
      emit(DoctorPatientsError('Failed to load patients'));
    } catch (e) {
      print('PATIENTS LIST CATCH: $e');
      emit(DoctorPatientsError('Something went wrong'));
    }
  }
}

class PatientDetailCubit extends Cubit<PatientDetailState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));

  PatientDetailCubit() : super(PatientDetailInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // GET /api/Profile/patientData?userId={id}
  Future<void> fetchPatient(String userId) async {
    emit(PatientDetailLoading());
    try {
      final r = await _dio.get(
        "/api/Profile/patientData",
        queryParameters: {"userId": userId},
        options: _authOptions,
      );
      print('PATIENT DETAIL RAW: ${r.data}');
      final patient = PatientModel.fromJson(
        Map<String, dynamic>.from(r.data as Map),
      );
      emit(PatientDetailLoaded(patient));
    } on DioException catch (e) {
      print('PATIENT DETAIL ERROR: ${e.response?.statusCode}');
      emit(PatientDetailError('Failed to load patient data'));
    } catch (e) {
      print('PATIENT DETAIL CATCH: $e');
      emit(PatientDetailError('Something went wrong'));
    }
  }

  // PUT /api/Appointment/complete/{appointmentId}
  Future<bool> completeAppointment(String appointmentId) async {
    try {
      await _dio.put(
        "/api/Appointment/complete/$appointmentId",
        options: _authOptions,
      );
      print('APPOINTMENT COMPLETED: $appointmentId');
      return true;
    } on DioException catch (e) {
      print('COMPLETE ERROR: ${e.response?.statusCode} - ${e.response?.data}');
      return false;
    } catch (e) {
      print('COMPLETE CATCH: $e');
      return false;
    }
  }
}