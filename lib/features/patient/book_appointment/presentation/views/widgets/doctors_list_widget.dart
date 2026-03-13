import 'package:flutter/material.dart';
import '../../../data/models/book_appointment_model.dart';
import 'doctor_card_widget.dart';

class DoctorsListWidget extends StatelessWidget {
  final List<BookAppointmentModel> doctors;
  final String? selectedDoctorId;
  final ValueChanged<BookAppointmentModel> onDoctorSelected;

  const DoctorsListWidget({
    super.key,
    required this.doctors,
    required this.selectedDoctorId,
    required this.onDoctorSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (doctors.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              const SizedBox(height: 12),
              Text(
                'No doctors found',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: doctors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return DoctorCardWidget(
          doctor: doctor,
          isSelected: doctor.id == selectedDoctorId,
          onTap: () => onDoctorSelected(doctor),
        );
      },
    );
  }
}
