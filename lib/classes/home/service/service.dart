import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/home/model/model.dart';

Future<bool> updateTotalCount(int count) async {
  try {
    // await FirebaseAuth.instance.currentUser!.updateDisplayName(profilePicture);
    await FirebaseFirestore.instance
        .collection(USERS_PATH)
        .doc(loginUserId())
        .update({
      'totalCount': FieldValue.increment(count),
    });
    debugPrint('Counter updated successfully');
    return true;
  } catch (e) {
    if (kDebugMode) {
      print('Failed to update Counter: $e');
    }
    return false;
  }
}

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to add a history record
  Future<void> addHistory(AddDataModel history, String collectionPath) async {
    try {
      DocumentReference docRef =
          _firestore.collection(collectionPath).doc(history.id);
      await docRef.set(history.toMap());
      // Optional: Return the document ID if needed
      // return docRef.id;
    } catch (error) {
      // Handle error appropriately
      throw Exception('Failed to add history: $error');
    }
  }

  // Method to update a history record
  Future<void> updateHistory(String collectionPath, String documentId,
      Map<String, dynamic> updates) async {
    try {
      DocumentReference docRef =
          _firestore.collection(collectionPath).doc(documentId);
      await docRef.update(updates);
    } catch (error) {
      // Handle error appropriately
      throw Exception('Failed to update history: $error');
    }
  }

  // Method to delete a history record
  Future<void> deleteHistory(String collectionPath, String documentId) async {
    try {
      DocumentReference docRef =
          _firestore.collection(collectionPath).doc(documentId);
      await docRef.delete();
    } catch (error) {
      // Handle error appropriately
      throw Exception('Failed to delete history: $error');
    }
  }

  // Method to retrieve a list of history records
  Future<List<AddDataModel>> getHistoryList(String collectionPath) async {
    try {
      QuerySnapshot snapshot =
          await _firestore.collection(collectionPath).get();
      return snapshot.docs
          .map((doc) => AddDataModel.fromDocument(doc))
          .toList();
    } catch (error) {
      // Handle error appropriately
      throw Exception('Failed to retrieve history: $error');
    }
  }
}
