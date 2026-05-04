// lib/features/patient/book_appointment/presentation/cubit/book_appointment_cubit.dart

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/patient/book_appointment/data/models/book_appointment_model.dart';
import 'book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
  );

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  BookAppointmentCubit() : super(BookAppointmentInitial());

  // ── Fetch all doctors ─────────────────────────────────────────────
  // GET /api/Appointment/Doctors
  Future<void> fetchDoctors() async {
    emit(BookAppointmentLoading());
    try {
      final response = await _dio.get(
        "/api/Appointment/Doctors",
        options: _authOptions,
      );

      final List<dynamic> data = response.data is List
          ? response.data
          : (response.data['data'] ?? response.data['doctors'] ?? []);

      // Debug — print first doctor to see exact field names
      if (data.isNotEmpty) print('DOCTOR RAW: ${data.first}');

      final doctors = data
          .whereType<Map>()
          .map((e) => BookAppointmentModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      emit(BookAppointmentLoaded(doctors));
    } on DioException catch (e) {
      print('FETCH DOCTORS ERROR: ${e.response?.data}');
      emit(BookAppointmentError(
        e.response?.data?['message'] ?? 'Failed to load doctors',
      ));
    } catch (e) {
      print('FETCH DOCTORS CATCH: $e');
      emit(BookAppointmentError('Something went wrong'));
    }
  }

  // ── Fetch available slots for a doctor ───────────────────────────
  // Step 1: GET /api/Calendly/doctor/{doctorId}/event-types → get eventTypeUri
  // Step 2: GET /api/Calendly/slots/{doctorId}?eventTypeUri={uri} → get slots
  Future<void> fetchSlots(String doctorId) async {
    emit(BookAppointmentSlotsLoading());
    try {
      // Step 1 — get event types to find the eventTypeUri
      String? eventTypeUri;
      try {
        final eventTypesResponse = await _dio.get(
          "/api/Calendly/doctor/$doctorId/event-types",
          options: _authOptions,
        );
        print('EVENT TYPES RAW: ${eventTypesResponse.data}');

        final List<dynamic> eventTypes = eventTypesResponse.data is List
            ? eventTypesResponse.data
            : (eventTypesResponse.data['data'] ??
                eventTypesResponse.data['eventTypes'] ??
                eventTypesResponse.data['collection'] ??
                []);

        if (eventTypes.isNotEmpty) {
          final first = eventTypes.first;
          eventTypeUri = (first['uri'] ??
                  first['id'] ??
                  first['eventTypeUri'] ??
                  '')
              .toString();
          print('Using eventTypeUri: $eventTypeUri');
        }
      } catch (e) {
        print('EVENT TYPES ERROR: \$e');
      }

      // Step 2 — get slots with eventTypeUri if available
      final queryParams = eventTypeUri != null && eventTypeUri.isNotEmpty
          ? {'eventTypeUri': eventTypeUri}
          : <String, String>{};

      final response = await _dio.get(
        "/api/Calendly/slots/$doctorId",
        queryParameters: queryParams,
        options: _authOptions,
      );

      print('SLOTS RAW: ${response.data}');

      final List<dynamic> raw = response.data is List
          ? response.data
          : (response.data['slots'] ??
              response.data['data'] ??
              response.data['availableSlots'] ??
              response.data['collection'] ??
              []);

      final slots = raw
          .whereType<Map>()
          .map((e) => CalendlySlot.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      emit(BookAppointmentSlotsLoaded(slots));
    } on DioException catch (e) {
      print('FETCH SLOTS ERROR: ${e.response?.data}');
      emit(BookAppointmentSlotsLoaded([]));
    } catch (e) {
      print('FETCH SLOTS CATCH: \$e');
      emit(BookAppointmentSlotsLoaded([]));
    }
  }

  // ── Book appointment ──────────────────────────────────────────────
  // POST /api/Appointment/book
  // Body: { doctorId, scheduledDate, reason, appointmentType }
  Future<void> bookAppointment({
    required String doctorId,
    required String scheduledDate, // ISO8601 string from Calendly slot
    required String reason,
    required String appointmentType, // "InPerson" or "VideoCall"
  }) async {
    emit(BookAppointmentBooking());
    try {
      await _dio.post(
        "/api/Appointment/book",
        data: {
          "doctorId": doctorId,
          "scheduledDate": scheduledDate,
          "reason": reason,
          "appointmentType": appointmentType,
        },
        options: _authOptions,
      );

      emit(BookAppointmentSuccess());
    } on DioException catch (e) {
      print('BOOK APPOINTMENT ERROR: ${e.response?.data}');
      emit(BookAppointmentError(
        e.response?.data?['message'] ?? 'Failed to book appointment',
      ));
    } catch (e) {
      print('BOOK APPOINTMENT CATCH: $e');
      emit(BookAppointmentError('Something went wrong'));
    }
  }
}