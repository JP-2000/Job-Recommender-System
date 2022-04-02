// import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:job_recommender_system/ui/custom.dart';
import 'package:job_recommender_system/ui/job.dart';
import 'package:job_recommender_system/ui/homepage.dart';
import 'package:job_recommender_system/ui/splashscreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'ui/user/signup_2.dart';
import 'ui/user/profile_setup/profile_setup.dart';
import 'package:job_recommender_system/ui/custom.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  // @override
  // Widget build(BuildContext context) {
  //   return AdaptiveTheme(
  //     light: ThemeData(
  //       brightness: Brightness.light,
  //       primarySwatch: white,
  //     ),
  //     dark: ThemeData(
  //         brightness: Brightness.dark,
  //         primarySwatch: white,
  //         primaryColor: Colors.white),
  //     initial: AdaptiveThemeMode.dark,
  //     builder: (theme, darkTheme) => MaterialApp(
  //       title: 'Adaptive Theme Demo',
  //       theme: theme,
  //       darkTheme: darkTheme,
  //       home: const SafeArea(child: HomePage()),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: black,
          primaryColor: Colors.blue),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: black,
        primaryColor: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      // home: const SafeArea(child: MyHomePage("WebView")),
      home: const SafeArea(child: Splash()),
    );
  }
}

const MaterialColor white = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);
const MaterialColor black = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Colors.black,
    100: Colors.black,
    200: Colors.black,
    300: Colors.black,
    400: Colors.black,
    500: Colors.black,
    600: Colors.black,
    700: Colors.black,
    800: Colors.black,
    900: Colors.black,
  },
);
