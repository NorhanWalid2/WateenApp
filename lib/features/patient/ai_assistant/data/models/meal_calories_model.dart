// lib/features/patient/ai_assistant/data/models/meal_calories_model.dart

class MealCaloriesModel {
  final String foodEn;
  final String foodAr;
  final int caloriesPer100g;
  final int estimatedWeightG;
  final int totalCalories;
  final double confidence;
  final String calculationMethod;
  final String requestedQuantity;
  final int foodId;
  final String reply; // Arabic explanation from AI

  MealCaloriesModel({
    required this.foodEn,
    required this.foodAr,
    required this.caloriesPer100g,
    required this.estimatedWeightG,
    required this.totalCalories,
    required this.confidence,
    required this.calculationMethod,
    required this.requestedQuantity,
    required this.foodId,
    required this.reply,
  });

  factory MealCaloriesModel.fromJson(Map<String, dynamic> json) {
    // Response is wrapped: { "data": { ... }, "reply": "..." }
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final reply = (json['reply'] ?? data['reply'] ?? '').toString();

    return MealCaloriesModel(
      foodEn: (data['food_en'] ?? data['food_En'] ?? '').toString(),
      foodAr: (data['food_ar'] ?? data['food_Ar'] ?? '').toString(),
      caloriesPer100g: _toInt(data['calories_per_100g']),
      estimatedWeightG: _toInt(data['estimated_weight_g']),
      totalCalories: _toInt(data['total_calories']),
      confidence: _toDouble(data['confidence']),
      calculationMethod: (data['calculation_method'] ?? '').toString(),
      requestedQuantity: (data['requested_quantity'] ?? '').toString(),
      foodId: _toInt(data['food_id']),
      reply: reply,
    );
  }

  static int _toInt(dynamic v) =>
      int.tryParse((v ?? 0).toString()) ?? 0;

  static double _toDouble(dynamic v) =>
      double.tryParse((v ?? 0).toString()) ?? 0.0;
}