import 'package:flutter/material.dart';
import 'package:wateen_app/features/patient/request_nurse/data/models/nurse_model.dart';
import 'nurse_card_widget.dart';

class NurseListWidget extends StatelessWidget {
  final List<NurseModel> nurses;
  final String? selectedNurseId;
  final ValueChanged<NurseModel> onNurseSelected;

  const NurseListWidget({
    super.key,
    required this.nurses,
    required this.selectedNurseId,
    required this.onNurseSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (nurses.isEmpty) {
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
                'No nurses found',
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
      itemCount: nurses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final nurse = nurses[index];
        return NurseCardWidget(
          nurse: nurse,
          isSelected: nurse.id == selectedNurseId,
          onTap: () => onNurseSelected(nurse),
        );
      },
    );
  }
}
