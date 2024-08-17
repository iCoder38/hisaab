import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_hisaab/classes/splash/splash.dart';

// import 'firebase_options.dart';

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  //
  await Firebase.initializeApp();

  runApp(
    const MaterialApp(
// remove debug banner from top right corner
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  );
}
