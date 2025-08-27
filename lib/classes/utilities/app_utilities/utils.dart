import 'package:flutter/material.dart';

class PolicyURL {
  String aboutUs =
      "https://thebluebamboo.in/APIs/MyHisaabAPIs/policies/about_us.html";
  String privacy =
      "https://thebluebamboo.in/APIs/MyHisaabAPIs/policies/privacy.html";
  String terms =
      "https://thebluebamboo.in/APIs/MyHisaabAPIs/policies/terms.html";
}

class KeyboardUtils {
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
