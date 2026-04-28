import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import '../../data/models/all_nurses_model.dart';
import 'all_nurses_state.dart';

class AllNursesCubit extends Cubit<AllNursesState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  AllNursesCubit() : super(AllNursesInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  List<AllNursesModel> get _currentNurses {
    final s = state;
    if (s is AllNursesLoaded) return s.nurses;
    if (s is AllNursesDeleteLoading) return s.nurses;
    if (s is AllNursesDeleteSuccess) return s.nurses;
    if (s is AllNursesDeleteError) return s.nurses;
    return [];
  }

  int get _currentTotal {
    final s = state;
    if (s is AllNursesLoaded) return s.totalCount;
    if (s is AllNursesDeleteLoading) return s.totalCount;
    if (s is AllNursesDeleteSuccess) return s.totalCount;
    if (s is AllNursesDeleteError) return s.totalCount;
    return 0;
  }

  Future<void> fetchNurses({int pageNumber = 1, int pageSize = 100}) async {
    emit(AllNursesLoading());
    try {
      final response = await _dio.get(
        "/api/HomeService/Nurses",
        queryParameters: {"pageNumber": pageNumber, "pageSize": pageSize},
        options: _authOptions,
      );
      final List data = (response.data['data'] as List?) ?? [];
      final totalCount = (response.data['totalCount'] as int?) ?? 0;
      final nurses =
          data.map((e) => AllNursesModel.fromJson(e)).toList();
      emit(AllNursesLoaded(nurses, totalCount));
    } on DioException catch (e) {
      emit(AllNursesError(
        e.response?.data?['message'] ?? 'Failed to load nurses',
      ));
    } catch (_) {
      emit(AllNursesError('Something went wrong'));
    }
  }

  Future<void> deleteNurse({required String nurseId}) async {
    final current = _currentNurses;
    final total = _currentTotal;
    emit(AllNursesDeleteLoading(current, total, nurseId));
    try {
      await _dio.delete(
        "/api/Admin/delete-account",
        options: _authOptions,
        data: {"id": nurseId},
      );
      final updated = current.where((n) => n.id != nurseId).toList();
      final newTotal = (total - 1).clamp(0, total);
      emit(AllNursesDeleteSuccess(updated, newTotal));
      emit(AllNursesLoaded(updated, newTotal));
    } on DioException catch (e) {
      print('DELETE NURSE ERROR: ${e.response?.statusCode} ${e.response?.data}');
      emit(AllNursesDeleteError(
        current,
        total,
        e.response?.data?['message'] ?? 'Failed to delete nurse',
      ));
      emit(AllNursesLoaded(current, total));
    } catch (_) {
      emit(AllNursesDeleteError(current, total, 'Something went wrong'));
      emit(AllNursesLoaded(current, total));
    }
  }
}