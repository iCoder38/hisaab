import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';

import 'package:indian_currency_to_word/indian_currency_to_word.dart';

class MonthHistoryScreen extends StatefulWidget {
  const MonthHistoryScreen({super.key, required this.strMonthName});

  final String strMonthName;

  @override
  State<MonthHistoryScreen> createState() => _MonthHistoryScreenState();
}

class _MonthHistoryScreenState extends State<MonthHistoryScreen> {
  //
  //
  final converter = AmountToWords();
  var strNavigationTitle = '';
  var strStoreAllPrices = [];
  var querySet = '1';
  var userSelect = '';
  //
  var arrList = [
    'Upwork',
    'Dishu Extra',
    'All',
    'POP',
    'SET : BIJLI',
    'Carpenter',
    'Painter',
    'Glass',
    'Chair',
    /*'Obonstore',
    'Credit Card Bill',
    'Grocery ( rashan )',
    'Market',
    'Gas ( Petrol , Diesel )',
    'Utilities ( Bijli, Water etc. )',*/
  ];

  var dishuArray = [
    'All',
    'Upwork',
    'Freelancer',
    'Dishu Extra',
  ];
  //
  var strUserSearch = 'All';
  //
  var strNewLoader = '0';
  var arrSaveAllMonthsData = [];

  //
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          //
          'History ( ${widget.strMonthName} )',
          Colors.black,
          18.0,
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
        actions: [
          IconButton(
            onPressed: () {
              //
              funcOpenTitleListDishu();
              // funcOpenTitleList();
            },
            icon: const Icon(
              Icons.menu,
            ),
          ),
        ],
      ),
      body: FirestoreListView<Map<String, dynamic>>(
        cacheExtent: 9999,
        pageSize: 10,
        reverse: false,
        query: strUserSearch.toString() == 'All'
            ? FirebaseFirestore.instance
                .collection(
                  '${strFirebaseMode}HISTORY',
                )
                .doc(loginUserId())
                .collection('LIST')
                .where('calendarMonth', isEqualTo: widget.strMonthName)
                .where(
                  'calendarYear',
                  isEqualTo: DateFormat('yyyy').format(
                    DateTime.now(),
                  ),
                )
                .orderBy('timeStamp', descending: true)
            : FirebaseFirestore.instance
                .collection(
                  '${strFirebaseMode}HISTORY',
                )
                .doc(loginUserId())
                .collection('LIST')
                .where('title', isEqualTo: strUserSearch.toString())
                .where('calendarMonth', isEqualTo: widget.strMonthName)
                .where(
                  'calendarYear',
                  isEqualTo: DateFormat('yyyy').format(
                    DateTime.now(),
                  ),
                )
                .orderBy('timeStamp', descending: true),
        itemBuilder: (context, snapshot) {
          Map<String, dynamic> communityData = snapshot.data();
          //
          return Column(
            children: [
              Container(
                // height: 220,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Column(
                  children: [
                    ListTile(
                      title: textWithRegularStyle(
                        communityData['title'],
                        Colors.black,
                        16.0,
                      ),
                      subtitle: textWithRegularStyle(
                        'INR: ${communityData['price']}\n\n${converter.convertAmountToWords(double.parse(communityData['price'].toString()))}\n',
                        Colors.black,
                        12.0,
                      ),
                    ),
                    const Divider(thickness: 0.2),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  funcOpenTitleListDishu() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('All Calculations'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          for (int i = 0; i < dishuArray.length; i++) ...[
            CupertinoActionSheetAction(
              onPressed: () async {
                //
                strUserSearch = dishuArray[i].toString();
                Navigator.pop(context);

                setState(() {
                  debugPrint(strUserSearch.toString());
                });

                //
              },
              child: textWithRegularStyle(
                dishuArray[i],
                Colors.black,
                14.0,
              ),
            ),
          ],
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: textWithRegularStyle(
              'Dismiss',
              Colors.redAccent,
              16.0,
            ),
          ),
        ],
      ),
    );
  }
}
