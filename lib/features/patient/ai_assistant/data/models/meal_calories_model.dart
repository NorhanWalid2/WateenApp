class MealCaloriesModel {
  final int calories;
  final String foodAr;
  final String foodEn;
  final String source;

  MealCaloriesModel({
    required this.calories,
    required this.foodAr,
    required this.foodEn,
    required this.source,
  });

  factory MealCaloriesModel.fromJson(Map<String, dynamic> json) {
    return MealCaloriesModel(
      calories: (json['calories'] as int?) ?? 0,
      foodAr: (json['food_Ar'] ?? '').toString(),
      foodEn: (json['food_En'] ?? '').toString(),
      source: (json['source'] ?? '').toString(),
    );
  }
}