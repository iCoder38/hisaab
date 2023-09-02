// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/admin_panel/admin_see_full_history/admin_see_full_history.dart';

import 'package:indian_currency_to_word/indian_currency_to_word.dart';

class AdminPanelMonthsListScreen extends StatefulWidget {
  const AdminPanelMonthsListScreen({super.key, this.getClickedUserData});

  final getClickedUserData;

  @override
  State<AdminPanelMonthsListScreen> createState() =>
      _AdminPanelMonthsListScreenState();
}

class _AdminPanelMonthsListScreenState
    extends State<AdminPanelMonthsListScreen> {
  //
  final converter = AmountToWords();
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
        title: Column(
          children: [
            //
            const SizedBox(
              height: 10,
            ),
            //
            textWithRegularStyle(
              'Months',
              Colors.black,
              18.0,
            ),
          ],
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
            Container(
              // height: 100,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    //
                    textWithBoldStyle(
                      ' ${widget.getClickedUserData['name'].toString()}',
                      Colors.black,
                      18.0,
                    ),
                    //
                    textWithRegularStyle(
                      '$indianRupeeSymbol ${NumberFormat('#,##,000').format(
                        int.parse(
                          widget.getClickedUserData['total_count'],
                        ),
                      )}',
                      Colors.black,
                      16.0,
                    ),
                    //
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: textWithRegularStyle(
                        // widget.getClickedUserData['total_count'],
                        converter.convertAmountToWords(double.parse(
                            widget.getClickedUserData['total_count'])),
                        Colors.black,
                        12.0,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                              builder: (context) => AdminSeeFullHistoryScreen(
                                  getFullData: widget.getClickedUserData,
                                  getMonthName: arrMonths[i]),
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
            )
            //
          ],
        ),
      ),
    );
  }
}
