// text with regular
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_hisaab/classes/login/login.dart';

// test mode
var strFirebaseMode = 'mode/test/';
/* ================================================================ */

var navigationColor = const Color.fromRGBO(213, 49, 63, 1);

var indianRupeeSymbol = '\u{20B9}';
/* ================================================================ */

var USERS_PATH = '${strFirebaseMode}USERS';

Text textWithRegularStyle(str, color, size) {
  return Text(
    str.toString(),
    style: GoogleFonts.montserrat(
      color: color,
      fontSize: size,
    ),
  );
}

// text with bold
Text textWithBoldStyle(str, color, size) {
  return Text(
    str.toString(),
    style: GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
    ),
  );
}

/* ================================================================ */
/* ========== CONVERT TIMESTAMP TO DATE AND TIME =============== */

funcConvertTimeStampToDateAndTime(getTimeStamp) {
  var dt = DateTime.fromMillisecondsSinceEpoch(getTimeStamp);
  var d12HourFormatDateAndTimeboth =
      DateFormat('dd / MMMM / yyyy , hh:mm a').format(dt);
  // var d12HourFormatTime = DateFormat('hh:mm a').format(dt);
  return d12HourFormatDateAndTimeboth;
}

/* ================================================================ */
/* ========== CREATE 16 DIGITS RANDOM NUMBER =============== */

String get16DigitNumber() {
  Random random = Random();
  String number = '';
  for (int i = 0; i < 16; i++) {
    number = number + random.nextInt(9).toString();
  }
  return number;
}

/* ================================================================ */
/* ================================================================ */

void showLoadingUI(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: textWithRegularStyle(
                    //
                    message,
                    //
                    Colors.black,
                    14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  //

  //
}

void logoutPopupUI(BuildContext context, String message) async {
  await showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: textWithRegularStyle(
                    //
                    message,
                    //
                    Colors.black,
                    14.0,
                  ),
                ),
              ),
              //
              const SizedBox(
                height: 20,
              ),
              //
              GestureDetector(
                onTap: () {
                  //
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                  //
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: textWithBoldStyle(
                    'yes, logout',
                    Colors.redAccent,
                    18.0,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}

String loginUserId() {
  var returnValue = FirebaseAuth.instance.currentUser!.uid;
  return returnValue;
}

String loginUserEmail() {
  var returnValue = FirebaseAuth.instance.currentUser!.email.toString();
  return returnValue;
}

String loginUserName() {
  var returnValue = FirebaseAuth.instance.currentUser!.displayName.toString();
  return returnValue;
}

int currentTimestamp() {
  var returnValue = DateTime.now().millisecondsSinceEpoch;
  return returnValue;
}
