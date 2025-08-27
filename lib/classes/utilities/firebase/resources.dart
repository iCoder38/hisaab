import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthUtils {
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;
  static String? get email => FirebaseAuth.instance.currentUser?.email;
  static String? get name => FirebaseAuth.instance.currentUser?.displayName;
}
