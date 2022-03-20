import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
        theme: ThemeData(primaryColor: const Color(0xFF0000d1)),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: "assets/splash_logo.png",
            splashIconSize: double.maxFinite,
            nextScreen: const HomePage(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: const Color.fromARGB(255, 235, 237, 240))
        //,
        );
  }
}
