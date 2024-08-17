import 'package:cloud_firestore/cloud_firestore.dart';

class AddDataModel {
  final String title;
  final String subTitle;
  final String price;
  final String userId;
  final String email;
  final String name;
  final String createdDate;
  final String id;
  final String calendarDate;
  final String calendarMonth;
  final String calendarYear;
  final int timeStamp;

  AddDataModel({
    required this.title,
    required this.subTitle,
    required this.price,
    required this.userId,
    required this.email,
    required this.name,
    required this.createdDate,
    required this.id,
    required this.calendarDate,
    required this.calendarMonth,
    required this.calendarYear,
    required this.timeStamp,
  });

  // Convert a HistoryModel to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subTitle': subTitle,
      'price': price,
      'userId': userId,
      'email': email,
      'name': name,
      'createdDate': createdDate,
      'id': id,
      'calendarDate': calendarDate,
      'calendarMonth': calendarMonth,
      'calendarYear': calendarYear,
      'timeStamp': timeStamp,
    };
  }

  // Create a HistoryModel from a Firestore document
  factory AddDataModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddDataModel(
      title: data['title'],
      subTitle: data['subTitle'],
      price: data['price'],
      userId: data['userId'],
      email: data['email'],
      name: data['name'],
      createdDate: data['createdDate'],
      id: data['id'],
      calendarDate: data['calendarDate'],
      calendarMonth: data['calendarMonth'],
      calendarYear: data['calendarYear'],
      timeStamp: data['timeStamp'],
    );
  }
}
