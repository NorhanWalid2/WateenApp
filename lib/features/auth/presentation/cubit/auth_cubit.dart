import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://wateen.runasp.net",
      headers: {"Content-Type": "application/json"},
    ),
  );

  AuthCubit() : super(AuthInitial());

  bool isPasswordVisible = false;
  bool rememberMe = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(AuthPasswordVisibilityChanged(isPasswordVisible));
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    emit(AuthInitial());
  }

  // ── Helper ─────────────────────────────────────
  String _getErrorMsg(DioException e) {
    if (e.response?.data is Map) {
      return e.response?.data['message'] ??
          e.response?.data['errors']?[0] ??
          'errorGeneral';
    }
    return 'errorGeneral';
  }

  // ── Register Patient ───────────────────────────
  Future<void> registerPatient({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required String gender,
    required String dateOfBirth,
    required String phoneNumber,
  }) async {
    emit(AuthLoading());
    try {
      final nameParts = fullName.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      // ✅ API expects "Male" or "Female" (capitalized)
      final genderEn = (gender == 'أنثى' || gender.toLowerCase() == 'female')
          ? 'Female'
          : 'Male';

      // ✅ Safe date parsing — format is DD/MM/YYYY from date picker
      if (dateOfBirth.isEmpty || !dateOfBirth.contains('/')) {
        emit(AuthFailure('Please select your date of birth'));
        return;
      }
      final parts = dateOfBirth.split('/');
      if (parts.length != 3) {
        emit(AuthFailure('Invalid date format'));
        return;
      }
      final isoDate = '${parts[2]}-${parts[1]}-${parts[0]}T00:00:00Z';

      debugPrint('=== REGISTER PATIENT body: firstName=$firstName, lastName=$lastName, gender=$genderEn, dob=$isoDate, phone=$phoneNumber');

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
          "phoneNumber": phoneNumber,
        },
      );
      emit(AuthSuccess());
    } on DioException catch (e) {
      debugPrint('=== REGISTER ERROR ${e.response?.statusCode}: ${e.response?.data}');
      emit(AuthFailure(_getErrorMsg(e)));
    } catch (e) {
      debugPrint('=== REGISTER UNEXPECTED: $e');
      emit(AuthFailure('errorGeneral'));
    }
  }
// ── Register Doctor ────────────────────────────────────────────────────────
  Future<void> registerDoctor({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String specialization,
    required String licenseNumber,
    required String workPlace,      // ✅ was "bio" before
    required String experienceYears, // ✅ was missing
  }) async {
    emit(AuthLoading());
    try {
      final nameParts = fullName.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final body = {
        "firstName":       firstName,
        "lastName":        lastName,
        "email":           email,
        "password":        password,
        "confirmPassword": confirmPassword,
        "specialization":  specialization,
        "licenseNumber":   licenseNumber,
        "phoneNumber":     phone,           // ✅ was "doctorPhoneNumber"
        "workPlace":       workPlace,       // ✅ was "bio"
        "experienceYears": int.tryParse(experienceYears) ?? 0, // ✅ was missing
      };

      debugPrint('=== REGISTER DOCTOR: $body');

      await _dio.post("/api/Auth/register/doctor", data: body);
      emit(AuthSuccess());
    } on DioException catch (e) {
      debugPrint('=== DOCTOR REGISTER ERROR ${e.response?.statusCode}: ${e.response?.data}');
      emit(AuthFailure(_getErrorMsg(e)));
    } catch (e) {
      debugPrint('=== DOCTOR REGISTER UNEXPECTED: $e');
      emit(AuthFailure('errorGeneral'));
    }
  }

  // ── Register Nurse ─────────────────────────────
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
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : firstName;

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
      emit(AuthFailure(_getErrorMsg(e)));
    } catch (e) {
      emit(AuthFailure('errorGeneral'));
    }
  }

  // ── Login ──────────────────────────────────────
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await _dio.post(
        "/api/Auth/login",
        data: {"email": email, "password": password},
      );

      final token = response.data['token'];
      await AppPrefs.setToken(token);
      final jwt = JWT.decode(token);
      final role =
          jwt.payload['role'] ??
          jwt.payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

      emit(AuthLoginSuccess(role: role.toString()));
    } on DioException catch (e) {
      emit(AuthFailure(_getErrorMsg(e)));
    } catch (e) {
      emit(AuthFailure('errorGeneral'));
    }
  }

  // ── Forgot Password ────────────────────────────────────────────────────────
  Future<void> forgotPassword({required String email}) async {
    emit(AuthLoading());
    try {
      await _dio.post(
        "/api/Auth/forgot-password",
        data: {"email": email},
      );
      emit(AuthForgotPasswordSuccess());
    } on DioException catch (e) {
      debugPrint('=== FORGOT ERROR ${e.response?.statusCode}: ${e.response?.data}');
      emit(AuthFailure(_getErrorMsg(e)));
    } catch (e) {
      emit(AuthFailure('errorGeneral'));
    }
  }

  // ── Reset Password ─────────────────────────────────────────────────────────
  Future<void> resetPassword({
    required String userId,
    required String token,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(AuthLoading());
    try {
      await _dio.post(
        "/api/Auth/reset-password",
        data: {
          "userId": userId,
          "token": token,
          "newPassword": newPassword,
          "confirmNewPassword": confirmNewPassword,
        },
      );
      emit(AuthResetPasswordSuccess());
    } on DioException catch (e) {
      debugPrint('=== RESET ERROR ${e.response?.statusCode}: ${e.response?.data}');
      emit(AuthFailure(_getErrorMsg(e)));
    } catch (e) {
      emit(AuthFailure('errorGeneral'));
    }
  }
}
