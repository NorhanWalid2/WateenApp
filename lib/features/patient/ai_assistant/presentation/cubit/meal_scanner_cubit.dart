// lib/features/patient/ai_assistant/presentation/cubit/meal_scanner_cubit.dart

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/ai_assistant/data/models/meal_calories_model.dart';
import 'meal_scanner_state.dart';

class MealScannerCubit extends Cubit<MealScannerState> {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://wateen.runasp.net"));

  MealScannerCubit() : super(MealScannerInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  // GET /api/AI/GetAICalories?food=mahshi
  Future<void> getCalories({required String food}) async {
    if (food.trim().isEmpty) return;
    emit(MealScannerLoading());
    try {
      final response = await _dio.get(
        "/api/AI/GetAICalories",
        queryParameters: {"food": food.trim()},
        options: _authOptions,
      );
      print('MEAL CALORIES RAW: ${response.data}');
      final result = MealCaloriesModel.fromJson(
          response.data as Map<String, dynamic>);
      emit(MealScannerLoaded(result));
    } on DioException catch (e) {
      print('MEAL CALORIES ERROR: ${e.response?.statusCode} ${e.response?.data}');
      final msg = e.response?.data;
      emit(MealScannerError(
        msg is Map ? (msg['message'] ?? 'Failed to get calories') : 'Failed to get calories',
      ));
    } catch (e) {
      print('MEAL CALORIES CATCH: $e');
      emit(MealScannerError('Something went wrong'));
    }
  }

  // POST /api/AI/GetAICaloriesByImage — multipart image upload
  Future<void> getCaloriesByImage({required File image}) async {
    emit(MealScannerLoading());
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });
      final response = await _dio.post(
        "/api/AI/GetAICaloriesByImage",
        data: formData,
        options: _authOptions,
      );
      print('MEAL IMAGE CALORIES RAW: ${response.data}');
      final result = MealCaloriesModel.fromJson(
          response.data as Map<String, dynamic>);
      emit(MealScannerLoaded(result));
    } on DioException catch (e) {
      print('MEAL IMAGE ERROR: ${e.response?.statusCode} ${e.response?.data}');
      final msg = e.response?.data;
      emit(MealScannerError(
        msg is Map ? (msg['message'] ?? 'Failed to scan image') : 'Failed to scan image',
      ));
    } catch (e) {
      print('MEAL IMAGE CATCH: $e');
      emit(MealScannerError('Something went wrong'));
    }
  }

  void reset() => emit(MealScannerInitial());
}