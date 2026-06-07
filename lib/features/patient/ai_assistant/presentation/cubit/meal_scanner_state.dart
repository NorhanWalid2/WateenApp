import 'package:wateen_app/features/patient/ai_assistant/data/models/meal_calories_model.dart';

 
abstract class MealScannerState {}

class MealScannerInitial extends MealScannerState {}

class MealScannerLoading extends MealScannerState {}

class MealScannerLoaded extends MealScannerState {
  final MealCaloriesModel result;
  MealScannerLoaded(this.result);
}

class MealScannerError extends MealScannerState {
  final String message;
  MealScannerError(this.message);
}