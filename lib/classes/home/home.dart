import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/history/months_list/months_list.dart';
import 'package:my_hisaab/classes/home/model/model.dart';
import 'package:my_hisaab/classes/home/service/service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  final formKey = GlobalKey<FormState>();
  late final TextEditingController contTitle;
  late final TextEditingController contSubTitle;
  late final TextEditingController contPrice;
  //
  var arrList = [
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
    'Upwork',
    'Freelancer',
    'Dishu Extra',
  ];
  //
  var strTotalPriceIs = '';
  //
  @override
  void initState() {
    super.initState();
    contTitle = TextEditingController();
    contSubTitle = TextEditingController();
    contPrice = TextEditingController();
    //
    // print(DateFormat('MMMM').format(DateTime.now()));
    //
  }

  @override
  void dispose() {
    contTitle.dispose();
    contSubTitle.dispose();
    contPrice.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              //
              logoutPopupUI(context, 'Are you sure you want to logout ?');
              //
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                //
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MonthsListScreen(
                      strGetTotalPrice: strTotalPriceIs,
                    ),
                  ),
                );
                //
              },
              icon: const Icon(
                Icons.description,
              ),
            ),
          ],
        ),
        body: _UIKIT(),
      ),
    );
  }

  Widget _UIKIT() {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(USERS_PATH)
            .where('userId', isEqualTo: loginUserId())
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
          if (snapshot2.hasData) {
            var saveSnapshotValue2 = snapshot2.data!.docs;

            // GET DATA WHEN IMAGE PERMISSION IS NOT EMPTY
            if (snapshot2.data!.docs.isNotEmpty) {
              //
              /*if (kDebugMode) {
                print('============================');
                print('HURRAY, YOU HAVE DATA');
                print(saveSnapshotValue2.length);
                print('============================');
              }*/
              strTotalPriceIs =
                  saveSnapshotValue2.first['totalCount'].toString();
            } else {
              /* if (kDebugMode) {
                print('============================');
                print('OOPS!, YOUR DATA IS EMPTY');
                print('============================');
              }*/
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            130,
                            201,
                            87,
                            233,
                          ),
                          borderRadius: BorderRadius.circular(
                            12.0,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //
                            textWithBoldStyle(
                              '\u{20B9} ${saveSnapshotValue2.first['totalCount'].toString()}',
                              Colors.black,
                              32.0,
                            ),
                          ],
                        ),
                      ),
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      //
                      Align(
                        alignment: Alignment.topLeft,
                        child: textWithRegularStyle(
                          'Title',
                          Colors.black,
                          14.0,
                        ),
                      ),
                      TextFormField(
                        readOnly: false,
                        controller: contTitle,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title...',
                        ),
                        onTap: () {
                          if (kDebugMode) {
                            print("I'm here!!!");
                          }
                          //
                          // funcOpenTitleListDishu();
                          // funcOpenTitleList();
                          //
                        },
                        // validation
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Title';
                          }
                          return null;
                        },
                      ),
                      //
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 0.4,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                      ),
                      //
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: textWithRegularStyle(
                          'Sub - Title',
                          Colors.black,
                          14.0,
                        ),
                      ),
                      TextFormField(
                        controller: contSubTitle,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Sub Title...',
                        ),

                        // validation
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                      ),
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 0.4,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                      ),
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: textWithRegularStyle(
                          'Price',
                          Colors.black,
                          14.0,
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: contPrice,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Price...',
                        ),

                        // validation
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      //
                      //
                      Container(
                        height: 0.4,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black,
                      ),
                      //
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            //
                            funcSumPriceWithTotal();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              130,
                              201,
                              87,
                              233,
                            ),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                // color: Colors.grey,
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                  0,
                                  3,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: textWithBoldStyle(
                              'Update',
                              Colors.white,
                              16.0,
                            ),
                          ),
                        ),
                      ),
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

  //
  //
  funcSumPriceWithTotal() {
    updateUserIntTrips(context);
  }

  updateUserIntTrips(context) async {
    bool success = await updateTotalCount(int.parse(contPrice.text.toString()));
    if (success) {
      debugPrint('ADDED');
      addDataInHistory(context);
    } else {
      debugPrint('ERROR');
    }
  }

  addDataInHistory(context) {
    debugPrint('${strFirebaseMode}HISTORY/${loginUserId()}/LIST');
    addHistoryToFirestore(context);
  }

  void addHistoryToFirestore(BuildContext context) async {
    final historyModel = AddDataModel(
      title: contTitle.text.toString(),
      subTitle: contSubTitle.text.toString(),
      price: contPrice.text.toString(),
      userId: loginUserId(),
      email: loginUserEmail(),
      name: loginUserName(),
      createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      id: get16DigitNumber(),
      calendarDate: DateFormat('dd').format(DateTime.now()),
      calendarMonth: DateFormat('MMMM').format(DateTime.now()),
      calendarYear: DateFormat('yyyy').format(DateTime.now()),
      timeStamp: currentTimestamp(),
    );

    final firestoreService = FirestoreService();

    try {
      await firestoreService.addHistory(
          historyModel, '${strFirebaseMode}HISTORY/${loginUserId()}/LIST');
      if (kDebugMode) {
        print('Data added successfully');
      }
      contPrice.text = '';
      contSubTitle.text = '';
      contTitle.text = '';
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: navigationColor,
          content: textWithBoldStyle(
            'Failed to add history. Please try again later.',
            Colors.white,
            14.0,
          ),
        ),
      );*/
    }
  }

  //

  /*funcAddNewPriceWithOldPrice(
    context,
    oldPrice,
    getElementId,
  ) {
    if (kDebugMode) {
      print('Old price is =====> $oldPrice');
      print('You entered price =====> ${contPrice.text}');
    }
    //
    // add both price now
    var addBothPrice = int.parse(oldPrice) + int.parse(contPrice.text);
    if (kDebugMode) {
      print('New price is =====> $addBothPrice');
    }
    //
    // update new price in xmpp
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}total_count")
        .doc(getElementId)
        .set(
      {
        'total_count': addBothPrice.toString(),
      },
      SetOptions(merge: true),
    ).then(
      (value1) {
        //
        funcCreateHistorySheetAlso(context);
        //
      },
    );
  }*/

  //
  /*funcCreateHistorySheetAlso(context) {
    CollectionReference users = FirebaseFirestore.instance.collection(
      '${strFirebaseMode}history_sheet/${DateFormat('MMMM').format(DateTime.now())}/${FirebaseAuth.instance.currentUser!.uid}',
    );

    users
        .add(
          {
            'title': contTitle.text.toString(),
            'sub_title': contSubTitle.text.toString(),
            'firebase_id': FirebaseAuth.instance.currentUser!.uid,
            'email': FirebaseAuth.instance.currentUser!.email,
            'id': get16DigitNumber(),
            'month_name': DateFormat('MMMM').format(DateTime.now()),
            'price': contPrice.text.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
          },
        )
        .then((value) => {
              // print(value.id),
              funcEditFirestoreIdInRegistration2(context, value.id),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: navigationColor,
                  content: textWithBoldStyle(
                    //
                    'Failed to add. Please try again after sometime.'
                        .toString(),
                    //
                    Colors.white,
                    14.0,
                  ),
                ),
              ),
            });
  }*/

  //
  /*funcEditFirestoreIdInRegistration2(context, elementId) {
    FirebaseFirestore.instance
        .collection(
            '${strFirebaseMode}history_sheet/${DateFormat('MMMM').format(DateTime.now())}/${FirebaseAuth.instance.currentUser!.uid}')
        .doc(elementId)
        .set(
      {
        'firestore_id': elementId,
      },
      SetOptions(merge: true),
    ).then(
      (value) {
        if (kDebugMode) {
          print('value 1.0');
        }
        //
        contPrice.text = '';
        contTitle.text = '';
        contSubTitle.text = '';
        //
        Navigator.pop(context);
        //
      },
    );
  }*/

  //
  //

  //
  // SAVE DATA IN HISTORY
  /*funcSaveDataInHistory() {
    FirebaseFirestore.instance
        .collection(
            "${strFirebaseMode}history_sheet/${DateFormat('MMMM').format(DateTime.now())}/details")
        .where("firebase_id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (kDebugMode) {
        print(value.docs);
      }

      if (value.docs.isEmpty) {
        if (kDebugMode) {
          print('======> NO USER FOUND');
        }

        //
      } else {
        for (var element in value.docs) {
          if (kDebugMode) {
            print('======> YES,  USER FOUND');
          }
          if (kDebugMode) {
            print(element.data());
            /*print(element.data()["company_name"]);
            print(element.id);
            print(element.id.runtimeType);*/
          }
          //
          // update month sheet
          //
          // update new price in xmpp
          FirebaseFirestore.instance
              .collection(
                  "${strFirebaseMode}history_sheet/${DateFormat('MMMM').format(DateTime.now())}/details")
              .doc(element.id)
              .set(
            {
              'month_count': contPrice.text.toString(),
            },
            SetOptions(merge: true),
          ).then(
            (value1) {
              //
              contPrice.text = '';
              contTitle.text = '';
              contSubTitle.text = '';
              //
            },
          );

          /**/
        }
      }
    });
  }*/

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
                contTitle.text = arrList[i].toString();
                Navigator.pop(context);
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
                contTitle.text = dishuArray[i].toString();
                Navigator.pop(context);
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
