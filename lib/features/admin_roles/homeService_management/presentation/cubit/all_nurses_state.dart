import '../../data/models/all_nurses_model.dart';

abstract class AllNursesState {}

class AllNursesInitial extends AllNursesState {}

class AllNursesLoading extends AllNursesState {}

class AllNursesLoaded extends AllNursesState {
  final List<AllNursesModel> nurses;
  final int totalCount;
  AllNursesLoaded(this.nurses, this.totalCount);
}

class AllNursesError extends AllNursesState {
  final String message;
  AllNursesError(this.message);
}

class AllNursesDeleteLoading extends AllNursesState {
  final List<AllNursesModel> nurses;
  final int totalCount;
  final String nurseId;
  AllNursesDeleteLoading(this.nurses, this.totalCount, this.nurseId);
}

class AllNursesDeleteSuccess extends AllNursesState {
  final List<AllNursesModel> nurses;
  final int totalCount;
  AllNursesDeleteSuccess(this.nurses, this.totalCount);
}

class AllNursesDeleteError extends AllNursesState {
  final List<AllNursesModel> nurses;
  final int totalCount;
  final String message;
  AllNursesDeleteError(this.nurses, this.totalCount, this.message);
}