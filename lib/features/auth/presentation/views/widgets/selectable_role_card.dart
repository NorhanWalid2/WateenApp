
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wateen_app/features/auth/data/model/role_model.dart';

class SelectableRoleCard extends StatelessWidget {
  const SelectableRoleCard({
    super.key,
    required this.colorScheme,
    required this.isSelected,
    required this.role,
  });

  final ColorScheme colorScheme;
  final bool isSelected;
  final RoleData role;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isSelected
                  ? colorScheme.secondary
                  : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(role.icon),
        ),
        title: Text(
          role.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          role.subtitle,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.outlineVariant,
          ),
        ),
        trailing: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color:
                  isSelected
                      ? colorScheme.secondary
                      : colorScheme.outline,
              width: 2,
            ),
            color:
                isSelected
                    ? colorScheme.secondary
                    : Colors.transparent,
          ),
          child:
              isSelected
                  ? const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  )
                  : null,
        ),
      ),
    );
  }
}

