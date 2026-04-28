import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import '../../data/models/nurse_profile_model.dart';
import 'nurse_profile_state.dart';

class NurseProfileCubit extends Cubit<NurseProfileState> {
  NurseProfileCubit() : super(NurseProfileInitial());

  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://wateen.runasp.net'),
  );

  Options get _authOptions => Options(
        headers: {
          'Authorization': 'Bearer ${AppPrefs.token}',
          'Content-Type': 'application/json',
        },
      );

  NurseProfileModel? get _loadedProfile {
    final s = state;
    if (s is NurseProfileLoaded) return s.profile;
    if (s is NurseProfileUpdating) return s.profile;
    if (s is NurseProfileUpdated) return s.profile;
    return null;
  }

  Future<void> fetchProfile() async {
    emit(NurseProfileLoading());

    try {
      final results = await Future.wait([
        _dio.get('/api/Profile', options: _authOptions),
        _dio.get('/api/Profile/nurseData', options: _authOptions),
      ]);

      print('PROFILE RAW: ${results[0].data}');
      print('NURSE DATA RAW: ${results[1].data}');

      final profile = NurseProfileModel.fromJson(
        profileJson: Map<String, dynamic>.from(results[0].data as Map),
        nurseJson: Map<String, dynamic>.from(results[1].data as Map),
      );

      emit(NurseProfileLoaded(profile));
    } on DioException catch (e) {
      print('NURSE PROFILE ERROR: ${e.response?.data}');
      emit(NurseProfileError(_extractError(e)));
    } catch (e, s) {
      print('NURSE PROFILE UNEXPECTED: $e');
      print(s);
      emit(NurseProfileError('Something went wrong'));
    }
  }

  Future<void> updateProfile({
    required NurseProfileModel oldProfile,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String specialization,
  }) async {
    emit(NurseProfileUpdating(oldProfile));

    try {
      final body = {
        'firstName': firstName.isEmpty ? oldProfile.firstName : firstName,
        'lastName': lastName.isEmpty ? oldProfile.lastName : lastName,
        'phoneNumber':
            phoneNumber.isEmpty ? oldProfile.phoneNumber : phoneNumber,
        'specialization':
            specialization.isEmpty ? oldProfile.specialization : specialization,
      };

      print('NURSE UPDATE BODY: $body');

      final response = await _dio.put(
        '/api/Profile/doctorNurse',
        options: _authOptions,
        data: body,
      );

      print('NURSE UPDATE RESPONSE: ${response.data}');

      await fetchProfile();
    } on DioException catch (e) {
      print('NURSE UPDATE ERROR: ${e.response?.data}');
      emit(NurseProfileLoaded(oldProfile));
      emit(NurseProfileError(_extractError(e)));
    } catch (e, s) {
      print('NURSE UPDATE UNEXPECTED: $e');
      print(s);
      emit(NurseProfileLoaded(oldProfile));
      emit(NurseProfileError('Something went wrong'));
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    final current = _loadedProfile;
    if (current == null) return;

    emit(NurseProfileUpdating(current));

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'profile.jpg',
          contentType: DioMediaType('image', 'jpeg'),
        ),
      });

      final response = await _dio.put(
        '/api/Profile/profile-picture',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppPrefs.token}',
          },
          contentType: 'multipart/form-data',
        ),
      );

      print('NURSE PICTURE RESPONSE: ${response.data}');

      await fetchProfile();
    } on DioException catch (e) {
      print('NURSE PICTURE ERROR: ${e.response?.data}');
      emit(NurseProfileLoaded(current));
      emit(NurseProfileError(_extractError(e)));
    } catch (e, s) {
      print('NURSE PICTURE UNEXPECTED: $e');
      print(s);
      emit(NurseProfileLoaded(current));
      emit(NurseProfileError('Something went wrong'));
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;

    if (data is Map) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['errors']?.toString() ??
          data['title']?.toString() ??
          'Request failed';
    }

    if (data is String) return data;

    return 'Request failed';
  }
}