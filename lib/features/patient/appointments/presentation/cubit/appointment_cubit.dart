import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/appointments/data/models/appointment_model.dart';
import 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://wateen.runasp.net'),
  );

  AppointmentCubit() : super(AppointmentInitial());

  Future<void> fetchAppointments() async {
    emit(AppointmentLoading());
    try {
      final response = await _dio.get(
        '/api/Appointment/Patient',
        queryParameters: {
          'pageNumber': 1,
          'pageSize': 50,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${AppPrefs.token}',
          },
        ),
      );

      final body = response.data;
      final List data = body is Map<String, dynamic>
          ? (body['data'] as List? ?? [])
          : (body as List? ?? []);

      final appointments = data
          .map((e) =>
              AppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList();

      final upcoming = appointments
          .where((a) => a.status == AppointmentStatus.upcoming)
          .toList();

      final past = appointments
          .where((a) => a.status == AppointmentStatus.past)
          .toList();

      emit(AppointmentLoaded(upcoming: upcoming, past: past));
    } on DioException catch (e) {
      emit(AppointmentError(
        e.response?.data?['message'] ?? 'Failed to load appointments',
      ));
    } catch (_) {
      emit(AppointmentError('Something went wrong'));
    }
  }
}