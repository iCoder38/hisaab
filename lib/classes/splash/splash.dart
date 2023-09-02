import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/admin_panel/admin_panel.dart';
import 'package:my_hisaab/classes/home/home.dart';
import 'package:my_hisaab/classes/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //
  Timer? timer;
  //
  @override
  void initState() {
    //
    funcCheckUserIsSignedInOrNot();
    //
    super.initState();
  }

  //
  funcCheckUserIsSignedInOrNot() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) {
        //
        if (t.tick == 2) {
          t.cancel();
          // func_push_to_next_screen();
          if (kDebugMode) {
            print('object');
          }
          //
          if (FirebaseAuth.instance.currentUser != null) {
            // signed in
            if (kDebugMode) {
              print('sign in');
            }
            //
            if (FirebaseAuth.instance.currentUser!.uid ==
                'Ir1ULWJP5NYLRndA4ZCMhnrlGr22') {
//
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminPanelScreen(),
                ),
              );
              //
            } else {
              //
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
              //
            }
          } else {
            // signed out
            //
            if (kDebugMode) {
              print('sign out');
            }
            //
            //
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ),
            );
            //
            //
          }

          //
        }
      },
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: textWithRegularStyle(
          'Hisaab',
          Colors.black,
          16.0,
        ),
      ),
    );
  }
}
