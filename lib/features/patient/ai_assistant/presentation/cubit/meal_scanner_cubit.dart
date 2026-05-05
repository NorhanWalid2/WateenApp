import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/ai_assistant/data/models/meal_calories_model.dart';
import 'meal_scanner_state.dart';

class MealScannerCubit extends Cubit<MealScannerState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
  );

  MealScannerCubit() : super(MealScannerInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  Future<void> getCalories({required String food}) async {
    if (food.trim().isEmpty) return;
    emit(MealScannerLoading());
    try {
      final response = await _dio.get(
        "/api/AI/GetAICalories",
        queryParameters: {"food": food.trim()},
        options: _authOptions,
      );
      final result = MealCaloriesModel.fromJson(response.data);
      emit(MealScannerLoaded(result));
    } on DioException catch (e) {
      emit(MealScannerError(
        e.response?.data?['message'] ?? 'Failed to get calories',
      ));
    } catch (_) {
      emit(MealScannerError('Something went wrong'));
    }
  }

  void reset() => emit(MealScannerInitial());
}