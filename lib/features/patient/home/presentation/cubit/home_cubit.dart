import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://wateen.runasp.net",
      headers: {"Content-Type": "application/json"},
    ),
  );

  HomeCubit() : super(HomeInitial());

  Future<void> fetchPatientProfile() async {
    emit(HomeLoading());
    try {
      // Attach the saved JWT token to the request
      final token = AppPrefs.token;
      final response = await _dio.get(
        "/api/Profile/patientData",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      final profile = PatientProfileModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      emit(HomeLoaded(profile));
    } on DioException catch (e) {
      final msg =
          (e.response?.data is Map)
              ? e.response?.data['message'] ?? 'Failed to load profile'
              : 'Failed to load profile';
      emit(HomeError(msg));
    } catch (_) {
      emit(HomeError('Something went wrong'));
    }
  }
}
