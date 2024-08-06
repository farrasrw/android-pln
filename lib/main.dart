import 'package:app_ocgf/provider/tabelgfr_provider.dart';
import 'package:app_ocgf/provider/tabelocr_provider.dart';
import 'package:app_ocgf/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAKhh6GWMfRumH53pnbw7TF2N7os2YAhZQ',
          appId: '1:287848300229:android:16097c47857bd81db73aac',
          messagingSenderId: '287848300229',
          projectId: 'appocgf01'));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataOcrProvider()),
        ChangeNotifierProvider(create: (context) => DataGfrProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppOCGF',
      home: SplashScreen(),
    );
  }
}
