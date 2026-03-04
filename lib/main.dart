import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wateen_app/core/routes/app_router.dart';
import 'package:wateen_app/core/theming/app_theme.dart';
import 'package:wateen_app/core/theming/theme_cubit.dart';
import 'package:wateen_app/core/theming/language_cubit.dart';
import 'package:wateen_app/l10n/app_localizations.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LanguageCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Wateen',

              // ── Theme ──────────────────────────
              themeMode: themeMode,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,

              // ── Localization ───────────────────
              locale: locale,
              supportedLocales: const [Locale('en'), Locale('ar')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              // ── Router ─────────────────────────
              routerConfig: router,

              // ── Smooth Theme Transition ────────
              builder:
                  (context, child) => AnimatedTheme(
                    data: Theme.of(context),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Directionality(
                      textDirection:
                          locale.languageCode == 'ar'
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                      child: child!,
                    ),
                  ),
            );
          },
        );
      },
    );
  }
}
