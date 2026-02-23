import 'package:flutter/material.dart';

class ThemeToggle extends StatelessWidget {
  final void Function(String themeMode) onThemeChanged;

  const ThemeToggle({super.key, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ThemeIconButton(
            icon: Icons.dark_mode_rounded,
            isSelected: isDark,
            onTap: () => onThemeChanged('dark'),
          ),
          _ThemeIconButton(
            icon: Icons.light_mode_rounded,
            isSelected: !isDark,
            onTap: () => onThemeChanged('light'),
          ),
        ],
      ),
    );
  }
}

class _ThemeIconButton extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeIconButton({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Uses your red primary as the selected highlight
          color:
              isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 20,
            color:
                isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
