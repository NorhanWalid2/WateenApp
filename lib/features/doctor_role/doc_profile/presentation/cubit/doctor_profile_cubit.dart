// lib/features/doctor_role/profile/presentation/cubit/doctor_profile_cubit.dart

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/doc_profile/data/models/doctor_profile_model.dart';
import 'doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));

  DoctorProfileCubit() : super(DoctorProfileInitial());

  Options get _auth =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // ── GET /api/Profile/doctorData ───────────────────────────────────
  Future<void> fetchProfile() async {
    emit(DoctorProfileLoading());
    try {
      final r = await _dio.get("/api/Profile/doctorData", options: _auth);
      print('DOCTOR PROFILE RAW: ${r.data}');

      // Merge with JWT claims for firstName/lastName/email
      final data = Map<String, dynamic>.from(r.data as Map);
      final jwtClaims = _decodeJwt();
      data['firstName'] = jwtClaims['given_name'] ?? data['firstName'] ?? '';
      data['email'] = jwtClaims['email'] ?? data['email'] ?? '';

      var profile = DoctorProfileModel.fromJson(data);

      // ✅ Restore saved profile picture from prefs if API doesn't return it
      if (profile.profilePictureUrl == null ||
          !profile.hasValidProfilePicture) {
        final savedUrl = AppPrefs.profilePictureUrl;
        if (savedUrl != null && savedUrl.startsWith('http')) {
          profile = DoctorProfileModel(
            id: profile.id,
            firstName: profile.firstName,
            lastName: profile.lastName,
            email: profile.email,
            phoneNumber: profile.phoneNumber,
            specialization: profile.specialization,
            licenseNumber: profile.licenseNumber,
            bio: profile.bio,
            education: profile.education,
            certifications: profile.certifications,
            workplace: profile.workplace,
            profilePictureUrl: savedUrl,
            experienceYears: profile.experienceYears,
          );
        }
      }

      emit(DoctorProfileLoaded(profile));
    } on DioException catch (e) {
      print('DOCTOR PROFILE ERROR: ${e.response?.statusCode}');
      emit(DoctorProfileError('Failed to load profile'));
    } catch (e) {
      print('DOCTOR PROFILE CATCH: $e');
      emit(DoctorProfileError('Something went wrong'));
    }
  }

  // ── PUT /api/Profile/doctorNurse ──────────────────────────────────
  // Body: { firstName, lastName, email, profilePictureUrl, education, certifications }
 Future<void> updateProfile({
  required String firstName,
  required String lastName,
  required String email,
  String? education,
  String? certifications,
  String? profilePictureUrl,
  String? bio,
}) async {
  final current = _currentProfile;
  if (current == null) return;

  emit(DoctorProfileUpdating(current));

  final body = {
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    if (education != null && education.isNotEmpty)
      "education": education,
    if (certifications != null && certifications.isNotEmpty)
      "certifications": certifications,
    if (profilePictureUrl != null &&
        profilePictureUrl.isNotEmpty)
      "profilePictureUrl": profilePictureUrl,
    if (bio != null && bio.isNotEmpty)
      "bio": bio,
  };

  print('UPDATE PROFILE BODY: $body');

  try {
    await _dio.put(
      "/api/Profile/doctorNurse",
      data: body,
      options: _auth,
    );

    print('PROFILE UPDATED');

    await fetchProfile();

    final updated = _currentProfile;

    if (updated != null) {
      emit(DoctorProfileUpdateSuccess(updated));
    }
  } on DioException catch (e) {
    print(
      'UPDATE PROFILE ERROR: ${e.response?.statusCode} - ${e.response?.data}',
    );

    final errData = e.response?.data;

    String msg = 'Failed to update profile';

    if (errData is Map) {
      msg =
          (errData['message'] ??
                  errData['title'] ??
                  msg)
              .toString();
    }

    emit(DoctorProfileUpdateError(msg, current));
  } catch (e) {
    print('UPDATE PROFILE CATCH: $e');

    emit(
      DoctorProfileUpdateError(
        'Something went wrong',
        current,
      ),
    );
  }
}
  // ── PUT /api/Profile/profile-picture ────────────────────────────
  // Body: multipart/form-data with 'file' field (binary)
  Future<void> uploadProfilePicture() async {
    final current = _currentProfile;
    if (current == null) return;

    try {
      // Pick image from gallery
      final picker = ImagePicker();
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );
      if (picked == null) return;

      emit(DoctorProfileUpdating(current));

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          picked.path,
          filename: picked.name,
        ),
      });

      final r = await _dio.put(
        "/api/Profile/profile-picture",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${AppPrefs.token}",
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      print('UPLOAD PICTURE RESPONSE: ${r.data}');

      // ✅ Use URL returned directly from upload response
      String? newUrl;
      if (r.data is Map) {
        newUrl = r.data['profilePictureUrl']?.toString();
      }

      // Refresh profile then patch in the new picture URL
      await fetchProfile();
      final refreshed = _currentProfile;
      if (refreshed != null && newUrl != null) {
        // Save to prefs so it persists
        await AppPrefs.saveProfilePicture(newUrl);
        emit(
          DoctorProfileLoaded(
            DoctorProfileModel(
              id: refreshed.id,
              firstName: refreshed.firstName,
              lastName: refreshed.lastName,
              email: refreshed.email,
              phoneNumber: refreshed.phoneNumber,
              specialization: refreshed.specialization,
              licenseNumber: refreshed.licenseNumber,
              bio: refreshed.bio,
              education: refreshed.education,
              certifications: refreshed.certifications,
              workplace: refreshed.workplace,
              profilePictureUrl: newUrl, // ✅ inject the new URL
              experienceYears: refreshed.experienceYears,
            ),
          ),
        );
      }
    } on DioException catch (e) {
      print(
        'UPLOAD PICTURE ERROR: ${e.response?.statusCode} - ${e.response?.data}',
      );
      if (current != null) {
        emit(DoctorProfileUpdateError('Failed to upload picture', current));
      }
    } catch (e) {
      print('UPLOAD PICTURE CATCH: $e');
      if (current != null) {
        emit(DoctorProfileUpdateError('Something went wrong', current));
      }
    }
  }

  DoctorProfileModel? get _currentProfile {
    final s = state;
    if (s is DoctorProfileLoaded) return s.profile;
    if (s is DoctorProfileUpdating) return s.profile;
    if (s is DoctorProfileUpdateSuccess) return s.profile;
    if (s is DoctorProfileUpdateError) return s.profile;
    return null;
  }

  // Decode JWT payload to get name/email
  Map<String, dynamic> _decodeJwt() {
    try {
      final token = AppPrefs.token ?? '';
      if (token.isEmpty) return {};
      final parts = token.split('.');
      if (parts.length < 2) return {};
      String payload = parts[1];
      while (payload.length % 4 != 0) payload += '=';
      final decoded = String.fromCharCodes(base64Url.decode(payload));
      return Map<String, dynamic>.from(jsonDecode(decoded));
    } catch (_) {
      return {};
    }
  }
}
