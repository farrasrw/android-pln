import 'package:flutter/material.dart';
import 'package:app_ocgf/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_ocgf/screens/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:app_ocgf/provider/tabelocr_provider.dart';
import 'package:app_ocgf/provider/tabelgfr_provider.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
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
      home:SplashScreen(),
    );
  }
}