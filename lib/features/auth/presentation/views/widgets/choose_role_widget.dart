import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_assets.dart';
import 'package:wateen_app/core/utls/app_textstyle.dart';

class ChooseRoleWidget extends StatelessWidget {
  const ChooseRoleWidget({
    required this.leading,
    super.key,
    required this.roleTitle,
    required this.subTitleRole,
    required this.onTap,
    required this.index,
    required this.selectedIndex,
  });
  final Widget leading;
  final String roleTitle;
  final String subTitleRole;
  final VoidCallback onTap;
  final int index;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final bool isSelected = index == selectedIndex;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform:
            isSelected ? (Matrix4.identity()..scale(1.01)) : Matrix4.identity(),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? colorScheme.secondary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: isSelected ? const Offset(0, 8) : const Offset(0, 0),
            ),
          ],
        ),
        child: ListTile(
          leading: leading,
          title: Text(roleTitle, style: AppTextstyle.archivo20(context)),
          subtitle: Text(
            subTitleRole,
            style: AppTextstyle.archivo15w400Gray(context),
          ),
          trailing: Image.asset(Assets.assetsImagesRightarrow),
        ),
      ),
    );
  }
}