import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/sign_up/model/model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUser(UserModel user, String collectionName) async {
    try {
      DocumentReference docRef =
          _firestore.collection(collectionName).doc(loginUserId());
      await docRef.set(user.toMap());
      // funcEditFirestoreIdInRegistration(docRef.id);
    } catch (error) {
      // Handle error, you can pass a callback for error handling
      throw Exception('Failed to add user: $error');
    }
  }

  // You can add more reusable methods here, such as updating, deleting, or retrieving users.
}
