import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/admin_roles/dashboard/presentation/cubit/admin_dashboard_state.dart';

class AdminStatsCubit extends Cubit<AdminStatsState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "http://wateen.runasp.net"),
  );

  AdminStatsCubit() : super(AdminStatsInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  int _parseCount(dynamic data) {
    if (data is int) return data;
    if (data is num) return data.toInt();

    if (data is Map) {
      return int.tryParse(
            (data['count'] ??
                    data['data'] ??
                    data['totalCount'] ??
                    data['value'] ??
                    0)
                .toString(),
          ) ??
          0;
    }

    return int.tryParse(data?.toString() ?? '0') ?? 0;
  }

  Future<void> fetchStats() async {
    emit(AdminStatsLoading());

    try {
      final results = await Future.wait([
        _dio.get("/api/Admin/users/count", options: _authOptions),
        _dio.get("/api/Admin/doctors/count", options: _authOptions),
        _dio.get("/api/Admin/nurses/count", options: _authOptions),
        _dio.get("/api/Admin/patients/count", options: _authOptions),
      ]);

      print("USERS COUNT RAW: ${results[0].data}");
      print("DOCTORS COUNT RAW: ${results[1].data}");
      print("NURSES COUNT RAW: ${results[2].data}");
      print("PATIENTS COUNT RAW: ${results[3].data}");

      emit(
        AdminStatsLoaded(
          usersCount: _parseCount(results[0].data),
          doctorsCount: _parseCount(results[1].data),
          nursesCount: _parseCount(results[2].data),
          patientsCount: _parseCount(results[3].data),
        ),
      );
    } on DioException catch (e) {
      print("ADMIN STATS ERROR: ${e.response?.statusCode}");
      print("ADMIN STATS DATA: ${e.response?.data}");

      final data = e.response?.data;
      final message = data is Map
          ? data['message']?.toString() ?? 'Failed to load stats'
          : 'Failed to load stats';

      emit(AdminStatsError(message));
    } catch (e, s) {
      print("ADMIN STATS UNEXPECTED: $e");
      print(s);
      emit(AdminStatsError('Something went wrong'));
    }
  }
}