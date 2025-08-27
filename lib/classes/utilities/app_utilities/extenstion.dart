import 'package:flutter/material.dart';

extension KeyboardDismiss on BuildContext {
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
