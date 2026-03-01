import 'package:flutter/material.dart';

class ThemeToggle extends StatefulWidget {
  final void Function(String themeMode) onThemeChanged;

  const ThemeToggle({super.key, required this.onThemeChanged});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();
}

class _ThemeToggleState extends State<ThemeToggle> {
  late bool _isDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDark = Theme.of(context).brightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        setState(() => _isDark = !_isDark); // ✅ local state يتغير فوري
        widget.onThemeChanged(_isDark ? 'dark' : 'light');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(4),
        width: 72,
        height: 36,
        decoration: BoxDecoration(
          color: _isDark ? colorScheme.secondary : colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: colorScheme.outline, width: 1),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: _isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: _isDark ? Colors.white : colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 16,
              color: _isDark ? colorScheme.secondary : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
