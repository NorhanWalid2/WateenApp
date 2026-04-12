import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://wateen.runasp.net",
      headers: {"Content-Type": "application/json"},
    ),
  );

  AuthCubit() : super(AuthInitial());
  Future<void> registerPatient({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dateOfBirth,
  }) async {
    emit(AuthLoading());
    try {
      final nameParts = fullName.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // تحويل الـ gender من عربي لإنجليزي
      final genderEn =
          (gender == 'أنثى' || gender == 'Female') ? 'female' : 'male';

      // تحويل الـ date من DD/MM/YYYY لـ ISO format
      final parts = dateOfBirth.split('/');
      final isoDate = '${parts[2]}-${parts[1]}-${parts[0]}T00:00:00Z';

      await _dio.post(
        "/api/Auth/register/Patient",
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "gender": genderEn,
          "dateOfBirth": isoDate,
        },
      );
      emit(AuthSuccess());
    } on DioException catch (e) {
      print("❌ Status: ${e.response?.statusCode}");
      print("❌ Data: ${e.response?.data}");
      final errorMsg =
          e.response?.data is Map
              ? (e.response?.data['message'] ?? "حدث خطأ، حاولي تاني")
              : "حدث خطأ، حاولي تاني";
      emit(AuthFailure(errorMsg));
    } catch (e) {
      print("❌ Unknown: $e");
      emit(AuthFailure("حدث خطأ، حاولي تاني"));
    }
  }

  Future<void> registerDoctor({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String specialization,
    required String licenseNumber,
    required String bio,
  }) async {
    emit(AuthLoading());
    try {
      final nameParts = fullName.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await _dio.post(
        "/api/Auth/register/doctor",
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "specialization": specialization,
          "licenseNumber": licenseNumber,
          "bio": bio,
          "doctorPhoneNumber": phone,
          "availabilitySchedule": "Not specified",
        },
      );
      emit(AuthSuccess());
    } on DioException catch (e) {
      print("❌ Status: ${e.response?.statusCode}");
      print("❌ Data: ${e.response?.data}");
      final errorMsg =
          e.response?.data is Map
              ? (e.response?.data['message'] ?? "حدث خطأ، حاولي تاني")
              : "حدث خطأ، حاولي تاني";
      emit(AuthFailure(errorMsg));
    } catch (e) {
      print("❌ Unknown: $e");
      emit(AuthFailure("حدث خطأ، حاولي تاني"));
    }
  }

  Future<void> registerNurse({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String licenseNumber,
    required String specialization,
    required int experienceYears,
  }) async {
    emit(AuthLoading());
    try {
      final nameParts = fullName.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await _dio.post(
        "/api/Auth/register/nurse",
        data: {
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
          "licenseNumber": licenseNumber,
          "specialization": specialization,
          "experienceYears": experienceYears,
          "nursePhoneNumber": phone,
          "isActive": true,
        },
      );
      emit(AuthSuccess());
    } on DioException catch (e) {
      print("❌ ERROR: ${e.response?.statusCode}");
      print("❌ DATA: ${e.response?.data}");
      emit(AuthFailure(e.response?.data['message'] ?? "حدث خطأ، حاولي تاني"));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _dio.post(
        "/api/Auth/login",
        data: {"email": email, "password": password},
      );
      emit(AuthSuccess());
    } on DioException catch (e) {
      print("❌ DioException type: ${e.type}");
      print("❌ Message: ${e.message}");
      print("❌ Response: ${e.response}");
      print("❌ Status: ${e.response?.statusCode}");
      print("❌ Data: ${e.response?.data}");

      final errorMsg =
          e.response?.data is Map
              ? (e.response?.data['message'] ?? "حدث خطأ، حاولي تاني")
              : "حدث خطأ، حاولي تاني";

      emit(AuthFailure(errorMsg));
    }
  }
}
