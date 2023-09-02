import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/history/month_history/month_history.dart';

class MonthsListScreen extends StatefulWidget {
  const MonthsListScreen({super.key, required this.strGetTotalPrice});

  final String strGetTotalPrice;

  @override
  State<MonthsListScreen> createState() => _MonthsListScreenState();
}

class _MonthsListScreenState extends State<MonthsListScreen> {
  //

  //
  var arrMonths = [
    'January',
    'Febuary',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithRegularStyle(
          'Months ( INR : ${widget.strGetTotalPrice} )',
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
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            for (int i = 0; i < arrMonths.length; i++) ...[
              InkWell(
                onTap: () {
                  //
                  if (kDebugMode) {
                    print('hello ====> $i');
                  }
                  //
                  //
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonthHistoryScreen(
                        strMonthName: arrMonths[i].toString(),
                      ),
                    ),
                  );
                  //
                },
                child: ListTile(
                  title: textWithBoldStyle(
                    arrMonths[i].toString(),
                    Colors.black,
                    16.0,
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                  ),
                ),
              ), //
              Container(
                height: 0.4,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey,
              )
            ],
          ],
        ),
      ),
    );
  }

  //
  funcCheckIsThisMonthContainAnyData(clickedMonthName) {
    FirebaseFirestore.instance
        .collection("${strFirebaseMode}history_sheet")
        .doc()
        .collection('')
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
          }
          //
          // update value total count
          /*funcAddNewPriceWithOldPrice(
            element.data()["total_count"].toString(),
            element.id,
          );*/
        }
      }
    });
  }
}
