import 'package:flutter/material.dart';
import 'package:wateen_app/core/utls/app_assets.dart';
import 'package:wateen_app/core/utls/app_colors.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(microseconds: 200),
        curve: Curves.easeOut,
        transform:
            isSelected ? (Matrix4.identity()..scale(1.01)) : Matrix4.identity(),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.grayColor : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: isSelected ? const Offset(0, 8) : const Offset(0, 0),
            ),
          ],
        ),
        child: ListTile(
          leading: leading,
          title: Text(roleTitle, style: AppTextstyle.archivo20),
          subtitle: Text(
            subTitleRole,
            style: AppTextstyle.archivo15w400.copyWith(
              color: AppColors.grayColor,
            ),
          ),
          trailing: Image.asset(Assets.assetsImagesRightarrow),
        ),
      ),
    );
  }
}
