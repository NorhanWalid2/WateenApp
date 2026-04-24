import 'package:flutter/material.dart';

class NurseHomeRequestModel {
  final String id;
  final String serviceDescription;
  final String requestedTime;
  final String address;
  final int status;
  final String patientId;
  final String nurseId;
  final String? nurseName;
  final String? patientName;

  NurseHomeRequestModel({
    required this.id,
    required this.serviceDescription,
    required this.requestedTime,
    required this.address,
    required this.status,
    required this.patientId,
    required this.nurseId,
    this.nurseName,
    this.patientName,
  });

  // ── Status helpers ────────────────────────────────────────────────
  String get statusLabel {
    switch (status) {
      case 1: return 'Approved';
      case 2: return 'Completed';
      case 3: return 'Rejected';
      default: return 'Pending';
    }
  }

  Color statusColor(ColorScheme colorScheme) {
    switch (status) {
      case 1: return const Color(0xFF16A34A);
      case 2: return const Color(0xFF3B82F6);
      case 3: return colorScheme.error;
      default: return const Color(0xFFF59E0B);
    }
  }

  IconData get statusIcon {
    switch (status) {
      case 1: return Icons.check_circle_rounded;
      case 2: return Icons.task_alt_rounded;
      case 3: return Icons.cancel_rounded;
      default: return Icons.access_time_rounded;
    }
  }

  // ── Formatted time ────────────────────────────────────────────────
  String get formattedTime {
    try {
      final dt = DateTime.parse(requestedTime).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return '${dt.day} ${months[dt.month - 1]}  $h:$m $ampm';
    } catch (_) {
      return requestedTime;
    }
  }

  // ── Copy with updated status ──────────────────────────────────────
  NurseHomeRequestModel copyWith({int? status}) {
    return NurseHomeRequestModel(
      id: id,
      serviceDescription: serviceDescription,
      requestedTime: requestedTime,
      address: address,
      status: status ?? this.status,
      patientId: patientId,
      nurseId: nurseId,
      nurseName: nurseName,
      patientName: patientName,
    );
  }

  factory NurseHomeRequestModel.fromJson(Map<String, dynamic> json) {
    return NurseHomeRequestModel(
      id: (json['id'] ?? '').toString(),
      serviceDescription: (json['serviceDescription'] ?? '').toString(),
      requestedTime: (json['requestedTime'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      status: (json['status'] as int?) ?? 0,
      patientId: (json['patientId'] ?? '').toString(),
      nurseId: (json['nurseId'] ?? '').toString(),
      nurseName: json['nurseName']?.toString(),
      patientName: json['patientName']?.toString(),
    );
  }
}