// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/sign_up/model/model.dart';
import 'package:my_hisaab/classes/sign_up/service/service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController contName;
  late final TextEditingController contEmail;
  late final TextEditingController contPassword;
  @override
  void initState() {
    super.initState();
    contName = TextEditingController();
    contEmail = TextEditingController();
    contPassword = TextEditingController();
  }

  @override
  void dispose() {
    contName.dispose();
    contEmail.dispose();
    contPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
        ),
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
                  controller: contName,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name...',
                  ),

                  // validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                ),
                //
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
                      funcCreateID();
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
                        'Sign Up',
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
                InkWell(
                  onTap: () {
                    //
                    Navigator.pop(context);
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  funcCreateID() async {
    showLoadingUI(context, 'please wait...');
    //
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: contEmail.text,
            password: contPassword.text,
          )
          .then((value) => {
                print('========================================='),
                print('=========== success signed up ==========='),
                print(value),
                //
                FirebaseAuth.instance.currentUser!
                    // .updateDisplayName(encrypted.base64.toString())
                    .updateDisplayName(contName.text)
                    .then((value) => {
                          // create user in DB
                          addUserToFirestore(context),
                        }),
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
        //
        Navigator.pop(context);
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
        //
        Navigator.pop(context);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
        // print(e);
      }
      //
      Navigator.pop(context);
    }
  }

  //
  void addUserToFirestore(BuildContext context) async {
    final userModel = UserModel(
      name: loginUserName(),
      userId: loginUserId(),
      email: loginUserEmail(),
      id: get16DigitNumber(),
      totalCount: 0,
      type: 'member',
    );

    final firestoreService = FirestoreService();

    try {
      await firestoreService
          .addUser(
        userModel,
        '${strFirebaseMode}USERS',
      )
          .then((v) {
        debugPrint('SignUp done');
        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: navigationColor,
          content: textWithBoldStyle(
            'Failed to add. Please try again after sometime.',
            Colors.white,
            14.0,
          ),
        ),
      );
    }
  }

  //
  //
  funcEditFirestoreIdInRegistration(elementId) {
    FirebaseFirestore.instance
        .collection('${strFirebaseMode}total_count')
        .doc(elementId)
        .set(
      {
        'firestore_id': elementId,
      },
      SetOptions(merge: true),
    ).then(
      (value) {
        if (kDebugMode) {
          print('value 1.0');
        }
        //
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  //
}
