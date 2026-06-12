// lib/features/patient/book_appointment/data/models/book_appointment_model.dart

class BookAppointmentModel {
  final String id;
  final String name;
  final String specialty;
  final String initials;
  final double rating;
  final int reviewCount;
  final String? profilePicture;
  final String? location;
  final int yearsExperience;
  final double consultationFee;
  final bool isAvailable;
  final String? education;
  final String? certification;
  final String? bio;

  const BookAppointmentModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.initials,
    required this.rating,
    required this.reviewCount,
    this.profilePicture,
    this.location,
    this.yearsExperience = 0,
    this.consultationFee = 0,
    this.isAvailable = true,
    this.education,
    this.certification,
    this.bio,
  });

  factory BookAppointmentModel.fromJson(Map<String, dynamic> json) {
    final name = (json['fullName'] ?? json['name'] ?? json['doctorName'] ?? 'Unknown').toString();
    final initials = name
        .trim()
        .split(' ')
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return BookAppointmentModel(
      id: (json['id'] ?? json['doctorId'] ?? '').toString(),
      name: name,
      specialty: (json['specialization'] ?? json['specialty'] ?? 'General').toString(),
      initials: initials.isEmpty ? 'DR' : initials,
      rating: double.tryParse((json['rating'] ?? 0).toString()) ?? 0.0,
      reviewCount: int.tryParse((json['reviewCount'] ?? json['reviews'] ?? 0).toString()) ?? 0,
      // ✅ API returns profilePictureUrl (not profilePicture)
      profilePicture: (json['profilePictureUrl'] ?? json['profilePicture'])?.toString(),
      location: json['location']?.toString() ?? json['city']?.toString(),
      yearsExperience: int.tryParse(
            (json['experienceYears'] ?? json['yearsOfExperience'] ?? json['experience'] ?? 0).toString(),
          ) ?? 0,
      consultationFee: double.tryParse(
            (json['consultationFee'] ?? json['fee'] ?? json['price'] ?? 0).toString(),
          ) ?? 0.0,
      isAvailable: json['isAvailable'] ?? true,
      // ✅ Confirmed field names from API response
      education: json['education']?.toString(),
      certification: json['certification']?.toString(),
      bio: json['bio']?.toString(),
    );
  }
}

class CalendlySlot {
  final String startTime;
  final String endTime;
  final String displayDate;
  final String displayTime;

  const CalendlySlot({
    required this.startTime,
    required this.endTime,
    required this.displayDate,
    required this.displayTime,
  });

  factory CalendlySlot.fromJson(Map<String, dynamic> json) {
    final rawStart = (json['startTime'] ?? json['start_time'] ?? json['start'] ?? '').toString();
    final rawEnd = (json['endTime'] ?? json['end_time'] ?? json['end'] ?? '').toString();

    String displayDate = '';
    String displayTime = '';

    try {
      final dt = DateTime.parse(rawStart).toLocal();
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      const weekdays = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
      displayDate = '${weekdays[dt.weekday - 1]}, ${months[dt.month - 1]} ${dt.day}';
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      displayTime = '$hour:$minute $period';
    } catch (_) {
      displayDate = rawStart;
    }

    return CalendlySlot(
      startTime: rawStart,
      endTime: rawEnd,
      displayDate: displayDate,
      displayTime: displayTime,
    );
  }
}