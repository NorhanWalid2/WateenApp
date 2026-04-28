abstract class AdminStatsState {}

class AdminStatsInitial extends AdminStatsState {}

class AdminStatsLoading extends AdminStatsState {}

class AdminStatsLoaded extends AdminStatsState {
  final int usersCount;
  final int doctorsCount;
  final int nursesCount;
  final int patientsCount;

  AdminStatsLoaded({
    required this.usersCount,
    required this.doctorsCount,
    required this.nursesCount,
    required this.patientsCount,
  });
}

class AdminStatsError extends AdminStatsState {
  final String message;
  AdminStatsError(this.message);
}