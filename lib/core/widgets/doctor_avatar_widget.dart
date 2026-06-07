// lib/core/widgets/doctor_avatar_widget.dart
//
// Reusable widget — shows doctor profile picture from URL
// Falls back to colored initials if no valid URL

import 'package:flutter/material.dart';

class DoctorAvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double radius;
  final Color? backgroundColor;
  final Color? initialsColor;

  const DoctorAvatarWidget({
    super.key,
    required this.imageUrl,
    required this.initials,
    this.radius = 24,
    this.backgroundColor,
    this.initialsColor,
  });

  bool get _hasValidUrl =>
      imageUrl != null &&
      (imageUrl!.startsWith('http://') || imageUrl!.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    const primaryRed = Color(0xFFDC2626);
    final bgColor = backgroundColor ?? primaryRed.withOpacity(0.12);
    final textColor = initialsColor ?? primaryRed;
    final fontSize = radius * 0.6;

    if (_hasValidUrl) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: bgColor,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Text(
        initials.isNotEmpty ? initials : '?',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}