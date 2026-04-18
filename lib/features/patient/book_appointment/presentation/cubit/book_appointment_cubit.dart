import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/book_appointment/data/models/book_appointment_model.dart';
import 'package:wateen_app/features/patient/book_appointment/presentation/cubit/book_appointment_state.dart';

// ── Cubit ──────────────────────────────────────────────────────────────────────
class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://wateen.runasp.net",
      headers: {"Content-Type": "application/json"},
    ),
  );

  BookAppointmentCubit() : super(BookAppointmentInitial());

  Options get _authOptions =>
      Options(headers: {"Authorization": "Bearer ${AppPrefs.token}"});

  Future<void> fetchDoctors() async {
    emit(BookAppointmentLoading());
    try {
      final response = await _dio.get(
        "/api/Appointment/Doctors",
        options: _authOptions,
      );
      debugPrint('=== DOCTORS RESPONSE: ${response.data}');
      final List data = response.data as List;
      final doctors = data
          .map((e) => BookAppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
      emit(BookAppointmentLoaded(doctors));
    } on DioException catch (e) {
      debugPrint('=== DOCTORS ERROR ${e.response?.statusCode}: ${e.response?.data}');
      emit(BookAppointmentError('Failed to load doctors'));
    } catch (e) {
      debugPrint('=== DOCTORS UNEXPECTED: $e');
      emit(BookAppointmentError('Something went wrong'));
    }
  }
}