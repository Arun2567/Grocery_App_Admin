import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_project/App_UI/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyBK5AyZ0DzDRPIR5ToxahOHWZsqxgwaLck",
              appId: "1:125363259246:android:c4301cb54aaff517cb637f",
              messagingSenderId: "125363259246",
              projectId: "my-project-5b113",
              storageBucket: "my-project-5b113.appspot.com",
          )
          ):
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).getTheme();
    return MaterialApp(
      theme:  theme,
      home:SplashScreen1(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData getTheme() => _isDarkMode ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}