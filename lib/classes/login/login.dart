// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/admin_panel/admin_panel.dart';
import 'package:my_hisaab/classes/home/home.dart';
import 'package:my_hisaab/classes/sign_up/sign_up.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController contEmail;
  late final TextEditingController contPassword;
  //

  //
  var emailIs = '';
  @override
  void initState() {
    contEmail = TextEditingController();
    contPassword = TextEditingController();
    //
    // FirebaseAuth.instance.signOut();

    //
    super.initState();
  }

  @override
  void dispose() {
    contEmail.dispose();
    contPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: contEmail,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Email...',
                    ),

                    // validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                  ),
                  //
                  TextFormField(
                    controller: contPassword,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password...',
                    ),

                    // validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  //
                  InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        signInViaFirebase();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: Center(
                        child: textWithBoldStyle(
                          'Sign In',
                          Colors.white,
                          16.0,
                        ),
                      ),
                    ),
                  ),
                  //
                  //
                  const SizedBox(
                    height: 20,
                  ),
                  //
                  InkWell(
                    onTap: () {
                      //
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                      //
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      child: Center(
                        child: textWithBoldStyle(
                          'Sign Up',
                          Colors.white,
                          16.0,
                        ),
                      ),
                    ),
                  )
                  //
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

/*Navigator.pop(context),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                ),
                */
  //
  signInViaFirebase() async {
    showLoadingUI(context, 'please wait...');
    //

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: contEmail.text, password: contPassword.text)
          .then((value) => {
                Navigator.pop(context),
                if (FirebaseAuth.instance.currentUser!.uid ==
                    'Ir1ULWJP5NYLRndA4ZCMhnrlGr22')
                  {
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPanelScreen(),
                      ),
                    ),
                    //
                  }
                else
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ),
                  }
              });
    } on FirebaseAuthException catch (e) {
      //
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: navigationColor,
          content: textWithBoldStyle(
            //
            e.toString(),
            //
            Colors.white,
            14.0,
          ),
        ),
      );
    } catch (e) {
      //
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: navigationColor,
          content: textWithBoldStyle(
            //
            e.toString(),
            //
            Colors.white,
            14.0,
          ),
        ),
      );
    }
  }

  // try {
  //   FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: contEmail.text, password: contPassword.text);
  // } catch (e) {

  //   Navigator.pop(context);
  //   switch (e.code) {
  //   case 'Error 17011':
  //     errorType = authProblems.UserNotFound;
  //     break;
  //   case 'Error 17009':
  //     errorType = authProblems.PasswordNotValid;
  //     break;
  //   case 'Error 17020':
  //     errorType = authProblems.NetworkError;
  //     break;
  //   // ...
  //   default:
  //     print('Case ${e.message} is not yet implemented');
  // }
  // }
}
