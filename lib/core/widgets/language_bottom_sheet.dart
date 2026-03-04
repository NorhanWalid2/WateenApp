import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/theming/language_cubit.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => BlocProvider.value(
            value: context.read<LanguageCubit>(),
            child: const LanguageBottomSheet(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = context.watch<LanguageCubit>().state.languageCode;

    final languages = [
      {'code': 'en', 'name': 'English', 'native': 'English'},
      {'code': 'ar', 'name': 'Arabic', 'native': 'العربية'},
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Title ─────────────────────────────
          Text(l10n.language, style: textTheme.titleLarge),
          const SizedBox(height: 20),

          // ── Language Options ──────────────────
          ...languages.map((lang) {
            final isSelected = currentLocale == lang['code'];
            return GestureDetector(
              onTap: () {
                context.read<LanguageCubit>().changeLanguage(lang['code']!);
                Navigator.pop(context);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? colorScheme.secondary.withOpacity(0.08)
                          : colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        isSelected
                            ? colorScheme.secondary
                            : colorScheme.outline,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // ── Flag emoji ──────────────
                    Text(
                      lang['code'] == 'ar' ? '🇸🇦' : '🇬🇧',
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),

                    // ── Language names ──────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lang['native']!,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected ? colorScheme.secondary : null,
                            ),
                          ),
                          Text(
                            lang['name']!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Check ───────────────────
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: colorScheme.secondary,
                        size: 22,
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
