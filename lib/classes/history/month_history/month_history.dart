import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  //
  var arrList = [
    'All',
    'Obonstore',
    'Credit Card Bill',
    'Grocery ( rashan )',
    'Market',
    'Gas ( Petrol , Diesel )',
    'Utilities ( Bijli, Water etc. )',
  ];
  //
  var strUserSearch = 'All';
  //
  var strNewLoader = '0';
  var arrSaveAllMonthsData = [];
  //
  @override
  void initState() {
    //
    /*Timestamp stamp = Timestamp.now();
    DateTime date = stamp.toDate();
    print(DateTime.parse('160789594'));*/
    //
    funcGetAllDetails();
    super.initState();
  }

  //
  funcGetAllDetails() {
    // showLoadingUI(context, 'please wait...');
    //
    if (kDebugMode) {
      // print('You entered price =====> ${contPrice.text}');
    }
    //

    FirebaseFirestore.instance
        .collection('${strFirebaseMode}history_sheet')
        .doc(widget.strMonthName.toString())
        .collection(FirebaseAuth.instance.currentUser!.uid)
        // .where('title', isEqualTo: strUserSearch.toString())
        .orderBy('time_stamp', descending: true)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          // print('======> NO USER FOUND');
        }
        //
      } else {
        for (var element in value.docs) {
          // if (kDebugMode) {
          // print('======> YES,  USER FOUND');
          // }
          if (kDebugMode) {
            // print(element.data());
            // print(element.data().length);
          }
          //
          arrSaveAllMonthsData.add(element.data());
        }
        //
        /*if (kDebugMode) {
          print('ALL DATA IS ');
          print(arrSaveAllMonthsData.length);
          print(arrSaveAllMonthsData);
        }*/
        //
        if (arrSaveAllMonthsData.isEmpty) {
        } else {
          var sum = 0;
          for (int i = 0; i < arrSaveAllMonthsData.length; i++) {
            //
            sum += int.parse(arrSaveAllMonthsData[i]['price'].toString());
          }
          strNavigationTitle = sum.toString();
          if (kDebugMode) {
            print('all done');
          }
          strNewLoader = '1';
          setState(() {});
        }
        //
        // Navigator.pop(context);
      }
    });
  }

  //
  funcFilter() {
    setState(() {
      strNewLoader = '0';
    });
    //
    funcGetAllDetailsWithFilter();
  }

  funcGetAllDetailsWithFilter() {
    //
    if (kDebugMode) {
      print('CLEAR ARRAY');
    }
    //
    arrSaveAllMonthsData.clear();
    //

    FirebaseFirestore.instance
        .collection('${strFirebaseMode}history_sheet')
        .doc(widget.strMonthName.toString())
        .collection(FirebaseAuth.instance.currentUser!.uid)
        // .where('title', isEqualTo: strUserSearch.toString())
        .orderBy('time_stamp', descending: true)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs);
      }

      var arrDummy = [];

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          // print('======> NO USER FOUND');
        }
        //
      } else {
        for (var element in value.docs) {
          // if (kDebugMode) {
          // print('======> YES,  USER FOUND');
          // }
          if (kDebugMode) {
            // print(element.data());
            // print(element.data().length);
          }
          //
          // arrSaveAllMonthsData.add(element.data());
          arrDummy.add(element.data());
        }
        //

        //
        if (arrDummy.isEmpty) {
        } else {
          var sum = 0;
          for (int i = 0; i < arrDummy.length; i++) {
            //

            if (arrDummy[i]['title'].toString() == strUserSearch.toString()) {
              sum += int.parse(arrDummy[i]['price'].toString());
              //
              arrSaveAllMonthsData.add(arrDummy[i]);
              //
            }
          }
          strNavigationTitle = sum.toString();
          if (kDebugMode) {
            print('all done');
          }

          setState(() {
            strNewLoader = '1';
          });
        }
        //
      }
    });
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
                funcOpenTitleList();
              },
              icon: const Icon(
                Icons.menu,
              ),
            ),
          ],
        ),
        body: (strNewLoader == '0')
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(
                          10.0,
                        ),
                        // height: 80,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            14.0,
                          ),
                          border: Border.all(
                            width: 0.2,
                          ),
                          color: const Color.fromRGBO(
                            252,
                            240,
                            254,
                            1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                0,
                                3,
                              ), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: textWithBoldStyle(
                                //
                                'INR : $strNavigationTitle',
                                // 'ok',
                                Colors.black,
                                18.0,
                              ),
                            ),

                            //
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: textWithRegularStyle(
                                //
                                converter.convertAmountToWords(
                                  double.parse(
                                    strNavigationTitle,
                                  ),
                                ),
                                Colors.black,
                                12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (int i = 0; i < arrSaveAllMonthsData.length; i++) ...[
                        ListTile(
                          title: textWithBoldStyle(
                            //
                            arrSaveAllMonthsData[i]['title'].toString(),
                            //
                            Colors.black,
                            16.0,
                          ),
                          subtitle: Column(
                            children: [
                              //
                              Align(
                                alignment: Alignment.centerLeft,
                                child: textWithRegularStyle(
                                  //
                                  arrSaveAllMonthsData[i]['sub_title']
                                      .toString(),
                                  Colors.black,
                                  14.0,
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
                                      arrSaveAllMonthsData[i]['time_stamp']),
                                  Colors.black,
                                  10.0,
                                ),
                              ),
                            ],
                          ),
                          trailing: textWithBoldStyle(
                            //
                            'INR : ${arrSaveAllMonthsData[i]['price'].toString()}',
                            //
                            Colors.black,
                            18.0,
                          ),
                        ),
                        //
                        Container(
                          height: 0.4,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black,
                        ),
                      ]
                    ],
                  ),
                ),
              ));
  }

  //
  // open action sheet of category
  //
  funcOpenTitleList() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('All Calculations'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          for (int i = 0; i < arrList.length; i++) ...[
            CupertinoActionSheetAction(
              onPressed: () async {
                //
                strUserSearch = arrList[i].toString();
                Navigator.pop(context);
                //
                if (strUserSearch == 'All') {
                  funcGetAllDetails();
                } else {
                  funcFilter();
                }

                //
              },
              child: textWithRegularStyle(
                arrList[i],
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
