// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';

class AdminSeeFullHistoryScreen extends StatefulWidget {
  const AdminSeeFullHistoryScreen(
      {super.key, this.getFullData, required this.getMonthName});

  final getFullData;
  final String getMonthName;

  @override
  State<AdminSeeFullHistoryScreen> createState() =>
      _AdminSeeFullHistoryScreenState();
}

class _AdminSeeFullHistoryScreenState extends State<AdminSeeFullHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History ( ${widget.getMonthName} )',
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            //
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('${strFirebaseMode}history_sheet')
            .doc(widget.getMonthName.toString())
            .collection(widget.getFullData['firebase_id'].toString())
            .orderBy('time_stamp', descending: true)
            // .snapshots(),
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
          if (snapshot2.hasData) {
            // if (kDebugMode) {

            var saveSnapshotValue2 = snapshot2.data!.docs;
            //

            // GET DATA WHEN IMAGE PERMISSION IS NOT EMPTY
            if (snapshot2.data!.docs.isNotEmpty) {
              //
              if (kDebugMode) {
                print('===================================');
                print('HURRAY, YOU HAVE DATA IN THIS MONTH');
                print(saveSnapshotValue2.length);
                print('============================');
              }
              //
            } else {
              if (kDebugMode) {
                print('============================');
                print('OOPS!, YOUR DATA IS EMPTY');
                print('============================');
              }
            }
            //
            if (saveSnapshotValue2.isEmpty) {
              return Center(
                child: textWithRegularStyle(
                  'No Data Found',
                  Colors.black,
                  18.0,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      for (int i = 0; i < saveSnapshotValue2.length; i++) ...[
                        ListTile(
                          title: textWithBoldStyle(
                            //
                            saveSnapshotValue2[i]['title'].toString(),
                            //
                            Colors.black,
                            18.0,
                          ),
                          subtitle: Column(
                            children: [
                              //
                              Align(
                                alignment: Alignment.centerLeft,
                                child: textWithRegularStyle(
                                  //
                                  saveSnapshotValue2[i]['sub_title'].toString(),
                                  //
                                  Colors.black,
                                  16.0,
                                ),
                              ),
                              //
                              const SizedBox(
                                height: 10,
                              ),
                              //
                              Align(
                                alignment: Alignment.centerLeft,
                                child: textWithRegularStyle(
                                  funcConvertTimeStampToDateAndTime(
                                    saveSnapshotValue2[i]['time_stamp'],
                                  ),
                                  Colors.black,
                                  10.0,
                                ),
                              ),
                            ],
                          ),
                          trailing: textWithBoldStyle(
                            //
                            // 'INR : ${saveSnapshotValue2[i]['price']}',
                            '$indianRupeeSymbol ${NumberFormat('#,##,000').format(
                              int.parse(
                                saveSnapshotValue2[i]['price'],
                              ),
                            )}',
                            //
                            Colors.black,
                            18.0,
                          ),
                        ),
                        //
                        Container(
                          height: 0.8,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                      ]
                    ],
                  ),
                ),
              );
            }
            //
          } else if (snapshot2.hasError) {
            if (kDebugMode) {
              print(snapshot2.error);
            }
            return Center(
              child: Text('Error: ${snapshot2.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
