import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wateen_app/core/routes/app_router.dart';
import 'package:wateen_app/core/theming/app_theme.dart';
import 'package:wateen_app/core/theming/theme_cubit.dart';

void main() {
  runApp(BlocProvider(create: (_) => ThemeCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Wateen App',
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          routerConfig: router,
        );
      },
    );
  }
}

// 1- add package flutter_native_splash in pubspec.yaml part of dependencies

// 2- design splash android and ios screens
//    download splash images (icon) in assets folder say splash_ios_android_11.png
// 3- design splash android 12 screen
//    # in figma create frame w:640 h:640 and r:320 and center the icon in this frame
//    # create new frame w:960 h:960 and center the last frame in this frame
//    # final export the frame as png and name it splash_ios_android_12.png
// 4- create file in rote app flutter_native_splash.yaml
//    # writhe in this code in this file 
      // flutter_native_splash:
      //   color: "#5F33E1"
      //   image: assets/images/splash_ios_android_11.png
      //   android_12:
      //     image: assets/images/splash_ios_android_12.png
      //     color: "#5F33E1"
// 4- run => dart run flutter_native_splash:create --path=flutter_native_splash.yaml



// 1- add package flutter_launcher_icons in pubspec.yaml dev_dependencies
// icons app logo
// 2- app IOS:
// # add image icon in assets say icon-launcher.png
// 3- app Android:
// # go to web page romannurik.github.io
// # download icon app
// # add icon in assets say play-store-icon-launcher.png

// write in pubspec.yaml part of dev_dependencies
// flutter_icons:
//   android: true
//   ios: true
//   image_path: "assets/icons/icon-launcher.png"
//   adaptive_icon_background: "#5F33E1"
//   adaptive_icon_foreground: "assets/icons/play-store-icon-launcher.png" 

// final run this
// flutter pub get
// flutter pub run flutter_launcher_icons