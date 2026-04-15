import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dio/dio.dart';
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
  }) async {
    emit(AuthLoading());
    try {
      final nameParts = fullName.trim().split(' ');
      final firstName = nameParts.first;
      final lastName =
          nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final genderEn =
          (gender == 'أنثى' || gender == 'Female') ? 'female' : 'male';

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
      emit(AuthFailure(_getErrorMsg(e)));
    } catch (e) {
      emit(AuthFailure('errorGeneral'));
    }
  }

  // ── Register Doctor ────────────────────────────
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
      emit(AuthFailure(_getErrorMsg(e)));
    } catch (e) {
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
}
