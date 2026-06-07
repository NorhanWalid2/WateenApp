import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/home/data/models/patient_profile_model.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://wateen.runasp.net",
      headers: {"Content-Type": "application/json"},
    ),
  );

  ProfileCubit() : super(ProfileInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // ── Fetch ──────────────────────────────────────────────────────
  Future<void> fetchPatientProfile() async {
    emit(ProfileLoading());
    try {
      final response = await _dio.get(
        "/api/Profile/patientData",
        options: _authOptions,
      );
      debugPrint('=== PROFILE RESPONSE: ${response.data}');

      PatientProfileModel profile = PatientProfileModel.fromJson(
        response.data as Map<String, dynamic>,
      );

      // ✅ Save userId from profile if not already saved
      // Try profile.id first, fall back to existing AppPrefs.userId
      try {
        final profileId = (profile as dynamic).id as String?;
        if (profileId != null && profileId.isNotEmpty) {
          await AppPrefs.saveUserId(profileId);
          debugPrint('=== SAVED userId: $profileId');
        }
      } catch (_) {
        // PatientProfileModel doesn't have id field — use existing userId
        debugPrint('=== userId from prefs: ${AppPrefs.userId}');
      }

      // ✅ Check if API returned a valid picture URL
      final isValidUrl = profile.profilePictureUrl != null &&
          (profile.profilePictureUrl!.startsWith('http://') ||
              profile.profilePictureUrl!.startsWith('https://'));

      if (isValidUrl) {
        // ✅ API returned a real URL — save it to prefs so it persists
        await AppPrefs.saveProfilePicture(profile.profilePictureUrl!);
        debugPrint('=== SAVED picture from API: ${profile.profilePictureUrl}');
      } else {
        // API returned invalid URL (e.g. "TEST.pNG") — restore from prefs
        final savedUrl = AppPrefs.profilePictureUrl;
        debugPrint('=== API url invalid, restoring from prefs: $savedUrl');
        if (savedUrl != null && savedUrl.isNotEmpty) {
          profile = PatientProfileModel(
            firstName:         profile.firstName,
            lastName:          profile.lastName,
            email:             profile.email,
            address:           profile.address,
            dateOfBirth:       profile.dateOfBirth,
            gender:            profile.gender,
            profilePictureUrl: savedUrl,
            phoneNumber:       profile.phoneNumber,
            nationalId:        profile.nationalId,
            bloodType:         profile.bloodType,
            systolicPressure:  profile.systolicPressure,
            diastolicPressure: profile.diastolicPressure,
            heartRate:         profile.heartRate,
            sugar:             profile.sugar,
          );
        }
      }

      emit(ProfileLoaded(profile));
    } on DioException catch (e) {
      debugPrint('=== FETCH ERROR ${e.response?.statusCode}: ${e.response?.data}');
      emit(ProfileError(_extractError(e)));
    } catch (e) {
      debugPrint('=== FETCH UNEXPECTED: $e');
      emit(ProfileError('Something went wrong'));
    }
  }

  // ── Update Profile ─────────────────────────────────────────────
  Future<void> updatePatientProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String address,
    required String dateOfBirth,
    required String gender,
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

      String resolvedDob;
      if (dateOfBirth.isNotEmpty) {
        resolvedDob = '${dateOfBirth}T00:00:00Z';
      } else {
        resolvedDob = current.dateOfBirth ?? DateTime.now().toUtc().toIso8601String();
      }

      final capitalizedGender = resolvedGender[0].toUpperCase() +
          resolvedGender.substring(1).toLowerCase();

      final body = {
        "firstName":   resolvedFirstName,
        "lastName":    resolvedLastName,
        "email":       resolvedEmail,
        "dateOfBirth": resolvedDob,
        "address":     resolvedAddress,
        "gender":      capitalizedGender,
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

  // ── Update Profile Picture ─────────────────────────────────────
  Future<void> updateProfilePicture(File imageFile) async {
    final current = _loadedProfile;
    if (current == null) return;

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile.jpg',
          contentType: DioMediaType('image', 'jpeg'),
        ),
      });

      final response = await _dio.put(
        "/api/Profile/profile-picture",
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer ${AppPrefs.token}"},
          contentType: 'multipart/form-data',
        ),
      );

      debugPrint('=== PICTURE RESPONSE: ${response.data}');

      final newUrl = response.data?['profilePictureUrl'] as String?;
      if (newUrl != null && newUrl.startsWith('http')) {
        // ✅ Save immediately — per-user key so it survives logout
        await AppPrefs.saveProfilePicture(newUrl);
        debugPrint('=== SAVED new picture: $newUrl');

        final updated = PatientProfileModel(
          firstName:         current.firstName,
          lastName:          current.lastName,
          email:             current.email,
          address:           current.address,
          dateOfBirth:       current.dateOfBirth,
          gender:            current.gender,
          profilePictureUrl: newUrl,
          phoneNumber:       current.phoneNumber,
          nationalId:        current.nationalId,
          bloodType:         current.bloodType,
          systolicPressure:  current.systolicPressure,
          diastolicPressure: current.diastolicPressure,
          heartRate:         current.heartRate,
          sugar:             current.sugar,
        );
        emit(ProfileLoaded(updated));
      }
    } on DioException catch (e) {
      debugPrint('=== PICTURE UPDATE ERROR ${e.response?.statusCode}: ${e.response?.data}');
    } catch (e) {
      debugPrint('=== PICTURE UNEXPECTED: $e');
    }
  }

  // ── Helpers ────────────────────────────────────────────────────
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