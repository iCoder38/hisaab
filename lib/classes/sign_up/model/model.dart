import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String userId;
  final String email;
  final String id;
  final int totalCount;
  final String type;

  UserModel({
    required this.name,
    required this.userId,
    required this.email,
    required this.id,
    required this.totalCount,
    required this.type,
  });

  // Convert a UserModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'userId': userId,
      'email': email,
      'id': id,
      'totalCount': totalCount,
      'type': type,
    };
  }

  // Create a UserModel from a Firestore document
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      name: data['name'],
      userId: data['userId'],
      email: data['email'],
      id: data['id'],
      totalCount: data['totalCount'],
      type: data['type'],
    );
  }
}
