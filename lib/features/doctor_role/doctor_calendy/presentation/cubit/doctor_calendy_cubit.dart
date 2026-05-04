// lib/features/doctor_role/calendly/presentation/cubit/doctor_calendly_cubit.dart

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/database/shared_prefference/app_prefs.dart';
import 'package:wateen_app/features/doctor_role/doctor_calendy/presentation/cubit/doctor_calendy_state.dart';
 
class DoctorCalendlyCubit extends Cubit<DoctorCalendlyState> {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: "https://wateen.runasp.net"),
  );

  DoctorCalendlyCubit() : super(DoctorCalendlyInitial());

  Options get _authOptions => Options(
        headers: {"Authorization": "Bearer ${AppPrefs.token}"},
      );

  // ── Connect Calendly → returns OAuth URL ─────────────────────────────────
  // GET /api/Calendly/connect
  Future<void> connectCalendly() async {
    emit(DoctorCalendlyConnecting());
    try {
      final response = await _dio.get(
        "/api/Calendly/connect",
        options: _authOptions,
      );

      // The API returns { authorizationUrl: "https://auth.calendly.com/..." }
      String url = '';
      final data = response.data;

      if (data is Map) {
        url = (data['authorizationUrl'] ??
                data['authorization_url'] ??
                data['authUrl'] ??
                data['url'] ??
                '')
            .toString();
      } else if (data is String) {
        // Sometimes the server returns the URL directly as plain text
        url = data.trim();
      }

      if (url.isEmpty || !url.startsWith('http')) {
        emit(DoctorCalendlyError('Invalid Calendly URL received from server'));
        return;
      }

      emit(DoctorCalendlyConnected(url));
    } on DioException catch (e) {
      print('CALENDLY CONNECT ERROR: ${e.response?.data}');
      emit(DoctorCalendlyError(
        e.response?.data?['message'] ?? 'Failed to connect Calendly',
      ));
    } catch (_) {
      emit(DoctorCalendlyError('Something went wrong'));
    }
  }

  // ── Fetch doctor's event types + slots ────────────────────────────────────
  // GET /api/Calendly/doctor/event-types
  // GET /api/Calendly/slots/{doctorId}
  Future<void> fetchCalendlyData() async {
    emit(DoctorCalendlyLoading());
    try {
      final doctorId = AppPrefs.userId ?? '';

      final results = await Future.wait([
        _dio.get("/api/Calendly/doctor/event-types", options: _authOptions),
        _dio.get("/api/Calendly/slots/$doctorId", options: _authOptions),
      ]);

      // Parse event types
      final eventTypesRaw = results[0].data;
      List<CalendlyEventTypeModel> eventTypes = [];
      if (eventTypesRaw is List) {
        eventTypes =
            eventTypesRaw.map((e) => CalendlyEventTypeModel.fromJson(e)).toList();
      } else if (eventTypesRaw is Map && eventTypesRaw['data'] != null) {
        eventTypes = (eventTypesRaw['data'] as List)
            .map((e) => CalendlyEventTypeModel.fromJson(e))
            .toList();
      }

      // Parse slots
      final slotsRaw = results[1].data;
      List<CalendlySlotModel> slots = [];
      if (slotsRaw is List) {
        slots = slotsRaw.map((e) => CalendlySlotModel.fromJson(e)).toList();
      } else if (slotsRaw is Map) {
        final slotList =
            slotsRaw['slots'] ?? slotsRaw['data'] ?? slotsRaw['availableSlots'] ?? [];
        slots =
            (slotList as List).map((e) => CalendlySlotModel.fromJson(e)).toList();
      }

      emit(DoctorCalendlyLoaded(
        eventTypes: eventTypes,
        slots: slots,
        isCalendlyLinked: eventTypes.isNotEmpty,
      ));
    } on DioException catch (e) {
      print('CALENDLY DATA ERROR: ${e.response?.data}');
      // If 401/403 → not connected yet
      final statusCode = e.response?.statusCode ?? 0;
      if (statusCode == 401 || statusCode == 403 || statusCode == 404) {
        emit(DoctorCalendlyLoaded(
          eventTypes: [],
          slots: [],
          isCalendlyLinked: false,
        ));
      } else {
        emit(DoctorCalendlyError(
          e.response?.data?['message'] ?? 'Failed to load Calendly data',
        ));
      }
    } catch (_) {
      emit(DoctorCalendlyError('Something went wrong'));
    }
  }
}