// lib/features/doctor_role/calendly/presentation/cubit/doctor_calendly_state.dart

abstract class DoctorCalendlyState {}

class DoctorCalendlyInitial extends DoctorCalendlyState {}

class DoctorCalendlyConnecting extends DoctorCalendlyState {}

class DoctorCalendlyConnected extends DoctorCalendlyState {
  final String connectUrl; // Calendly OAuth URL to open in browser
  DoctorCalendlyConnected(this.connectUrl);
}

class DoctorCalendlyLoading extends DoctorCalendlyState {}

class DoctorCalendlyLoaded extends DoctorCalendlyState {
  final List<CalendlyEventTypeModel> eventTypes;
  final List<CalendlySlotModel> slots;
  final bool isCalendlyLinked;

  DoctorCalendlyLoaded({
    required this.eventTypes,
    required this.slots,
    required this.isCalendlyLinked,
  });
}

class DoctorCalendlyError extends DoctorCalendlyState {
  final String message;
  DoctorCalendlyError(this.message);
}

// ── Models ─────────────────────────────────────────────────────────────────

class CalendlyEventTypeModel {
  final String id;
  final String name;
  final int durationMinutes;
  final String color;
  final String schedulingUrl;
  final bool active;

  CalendlyEventTypeModel({
    required this.id,
    required this.name,
    required this.durationMinutes,
    required this.color,
    required this.schedulingUrl,
    required this.active,
  });

  factory CalendlyEventTypeModel.fromJson(Map<String, dynamic> json) {
    return CalendlyEventTypeModel(
      id: (json['id'] ?? json['uri'] ?? '').toString(),
      name: json['name'] ?? json['title'] ?? 'Appointment',
      durationMinutes: int.tryParse(
              (json['duration'] ?? json['durationMinutes'] ?? 30).toString()) ??
          30,
      color: json['color'] ?? '#3B82F6',
      schedulingUrl: json['schedulingUrl'] ?? json['scheduling_url'] ?? '',
      active: json['active'] ?? true,
    );
  }
}

class CalendlySlotModel {
  final String startTime;
  final String endTime;
  final String date;
  final String displayTime;

  CalendlySlotModel({
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.displayTime,
  });

  factory CalendlySlotModel.fromJson(Map<String, dynamic> json) {
    final rawStart = json['startTime'] ?? json['start_time'] ?? '';
    String date = '';
    String displayTime = '';

    try {
      final dt = DateTime.parse(rawStart.toString()).toLocal();
      const months = [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ];
      const weekdays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
      date =
          '${weekdays[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}';
      final hour =
          dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      displayTime = '$hour:$minute $period';
    } catch (_) {
      date = rawStart.toString();
    }

    return CalendlySlotModel(
      startTime: rawStart.toString(),
      endTime: (json['endTime'] ?? json['end_time'] ?? '').toString(),
      date: date,
      displayTime: displayTime,
    );
  }
}