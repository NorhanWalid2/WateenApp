import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/nurse/reports/data/models/report_model.dart';
import 'package:wateen_app/features/nurse/reports/presentation/cubit/report_state.dart';
 

class ReportsCubit extends Cubit<ReportsState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
  );

  ReportsCubit() : super(ReportsInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  Future<void> fetchMyPatients() async {
    emit(ReportsLoading());
    try {
      final response = await _dio.get(
        "/api/HomeService/MyPatients",
        queryParameters: {"pageNumber": 1, "pageSize": 100},
        options: _authOptions,
      );
      print('MY PATIENTS RAW: ${response.data}');
      final List data = (response.data['data'] as List?) ?? [];
      final totalCount = (response.data['totalCount'] as int?) ?? 0;
      final patients =
          data.map((e) => ReportModel.fromJson(e)).toList();
      emit(ReportsLoaded(patients, totalCount));
    } on DioException catch (e) {
      print('PATIENTS ERROR: ${e.response?.data}');
      emit(ReportsError(
        e.response?.data?['message'] ?? 'Failed to load patients',
      ));
    } catch (e) {
      emit(ReportsError('Something went wrong'));
    }
  }
}