import 'package:flutter/material.dart';

class ProfileGenderSelectorWidget extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const ProfileGenderSelectorWidget({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENDER',
          style: textTheme.bodySmall?.copyWith(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: ['male', 'female'].map((g) {
            final isSelected = selected == g;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(g),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: g == 'male' ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.secondary
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.secondary
                          : colorScheme.outline.withOpacity(0.4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        g == 'male'
                            ? Icons.male_rounded
                            : Icons.female_rounded,
                        color: isSelected
                            ? Colors.white
                            : colorScheme.onSurfaceVariant,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        g == 'male' ? 'Male' : 'Female',
                        style: textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? Colors.white
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}