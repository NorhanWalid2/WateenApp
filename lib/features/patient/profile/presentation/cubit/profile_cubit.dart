import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://wateen.runasp.net",
      headers: {"Content-Type": "application/json"},
    ),
  );

  ProfileCubit() : super(ProfileInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // ── Fetch ──────────────────────────────────────────────────────────────────
  Future<void> fetchPatientProfile() async {
    emit(ProfileLoading());
    try {
      final response = await _dio.get(
        "/api/Profile/patientData",
        options: _authOptions,
      );
      debugPrint('=== PROFILE RESPONSE: ${response.data}');
      final profile = PatientProfileModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      emit(ProfileLoaded(profile));
    } on DioException catch (e) {
      debugPrint('=== FETCH ERROR ${e.response?.statusCode}: ${e.response?.data}');
      emit(ProfileError(_extractError(e)));
    } catch (e) {
      debugPrint('=== FETCH UNEXPECTED: $e');
      emit(ProfileError('Something went wrong'));
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────────
  Future<void> updatePatientProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required String dateOfBirth,
    required String gender,
    String? profilePictureUrl,
  }) async {
    final current = _loadedProfile;
    if (current == null) return;

    emit(ProfileUpdating(current));
    try {
      final resolvedFirstName = firstName.isNotEmpty ? firstName : current.firstName;
      final resolvedLastName  = lastName.isNotEmpty  ? lastName  : current.lastName;
      final resolvedEmail     = email.isNotEmpty     ? email     : current.email;
      final resolvedAddress   = address.isNotEmpty   ? address   : (current.address ?? '');
      final resolvedGender    = gender.isNotEmpty    ? gender    : (current.gender ?? 'male');

      // Convert YYYY-MM-DD → YYYY-MM-DDT00:00:00Z
      String resolvedDob;
      if (dateOfBirth.isNotEmpty) {
        resolvedDob = '${dateOfBirth}T00:00:00Z';
      } else {
        resolvedDob = current.dateOfBirth ?? DateTime.now().toUtc().toIso8601String();
      }

      // API requires "Male" or "Female" capitalized
      final capitalizedGender = resolvedGender[0].toUpperCase() +
          resolvedGender.substring(1).toLowerCase();

      final body = {
        "firstName":         resolvedFirstName,
        "lastName":          resolvedLastName,
        "email":             resolvedEmail,
        "profilePictureUrl": profilePictureUrl ?? current.profilePictureUrl ?? '',
        "dateOfBirth":       resolvedDob,
        "address":           resolvedAddress,
        "gender":            capitalizedGender,
      };

      debugPrint('=== PUT body: $body');

      await _dio.put(
        "/api/Profile/patient",
        data: body,
        options: _authOptions,
      );

      final updated = PatientProfileModel(
        firstName:         resolvedFirstName,
        lastName:          resolvedLastName,
        email:             resolvedEmail,
        address:           resolvedAddress,
        dateOfBirth:       resolvedDob,
        gender:            resolvedGender,
        profilePictureUrl: current.profilePictureUrl,
        phoneNumber:       current.phoneNumber,
        nationalId:        current.nationalId,
        bloodType:         current.bloodType,
        systolicPressure:  current.systolicPressure,
        diastolicPressure: current.diastolicPressure,
        heartRate:         current.heartRate,
        sugar:             current.sugar,
      );

      emit(ProfileUpdateSuccess(updated));
      emit(ProfileLoaded(updated));
    } on DioException catch (e) {
      debugPrint('=== UPDATE ERROR ${e.response?.statusCode}: ${e.response?.data}');
      emit(ProfileLoaded(current));
      emit(ProfileUpdateError(current, _extractError(e)));
    } catch (e) {
      debugPrint('=== UNEXPECTED: $e');
      emit(ProfileLoaded(current));
      emit(ProfileUpdateError(current, 'Something went wrong'));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  PatientProfileModel? get _loadedProfile {
    final s = state;
    if (s is ProfileLoaded) return s.profile;
    if (s is ProfileUpdating) return s.profile;
    if (s is ProfileUpdateSuccess) return s.profile;
    if (s is ProfileUpdateError) return s.profile;
    return null;
  }

  String _extractError(DioException e) {
    if (e.response?.data is Map) {
      final errors = e.response?.data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstList = errors.values.first;
        if (firstList is List && firstList.isNotEmpty) {
          return firstList.first.toString();
        }
      }
      return e.response?.data['message'] ??
          e.response?.data['title'] ??
          'Request failed';
    }
    return 'Request failed';
  }
}