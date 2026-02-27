import 'package:wateen_app/core/enums/user_role.dart';

class RoleData {
  final String title;
  final String subtitle;
  final String icon;
  final UserRole role;

  const RoleData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.role,
  });
}
