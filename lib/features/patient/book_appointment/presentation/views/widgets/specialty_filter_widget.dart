import 'package:flutter/material.dart';

class SpecialtyFilterWidget extends StatelessWidget {
  final List<String> specialties;
  final String selected;
  final ValueChanged<String> onSelected;

  const SpecialtyFilterWidget({
    super.key,
    required this.specialties,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: specialties.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final specialty = specialties[index];
          final isActive = specialty == selected;
          return GestureDetector(
            onTap: () => onSelected(specialty),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isActive
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color:
                      isActive
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.outlineVariant,
                  width: 1.5,
                ),
              ),
              child: Text(
                specialty,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color:
                      isActive
                          ? Colors.white
                          : Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
