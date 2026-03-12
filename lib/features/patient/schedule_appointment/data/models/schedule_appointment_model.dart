class ScheduleAppointmentModel {
  final String appointmentType;
  final DateTime date;
  final String time;
  final String? notes;

  ScheduleAppointmentModel({
    required this.appointmentType,
    required this.date,
    required this.time,
    this.notes,
  });
}
