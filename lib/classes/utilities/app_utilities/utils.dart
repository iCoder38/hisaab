import 'package:flutter/material.dart';

class KeyboardUtils {
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
