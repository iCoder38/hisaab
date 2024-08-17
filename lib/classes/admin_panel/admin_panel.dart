import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_hisaab/classes/Utils/utils.dart';
import 'package:my_hisaab/classes/admin_panel/admin_panel_months_list/admin_panel_months_list.dart';
import 'package:my_hisaab/classes/history/months_list/months_list.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWithBoldStyle(
          'Admin',
          Colors.black,
          22.0,
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
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('${strFirebaseMode}total_count')
            .where('type', isEqualTo: 'member')
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
          if (snapshot2.hasData) {
            // if (kDebugMode) {

            var saveSnapshotValue2 = snapshot2.data!.docs;
            //

            //
            if (snapshot2.data!.docs.isNotEmpty) {
              //
              if (kDebugMode) {
                print('============================');
                print('HURRAY, ADMIN YES');
                print(saveSnapshotValue2.length);
                print('============================');
              }
              //
            } else {
              if (kDebugMode) {
                print('============================');
                print('OOPS!, ADMIN NO');
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
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      for (int i = 0; i < saveSnapshotValue2.length; i++) ...[
                        InkWell(
                          onTap: () {
                            //
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AdminPanelMonthsListScreen(
                                  getClickedUserData:
                                      saveSnapshotValue2[i].data(),
                                ),
                              ),
                            );
                            //
                          },
                          child: ListTile(
                            title: textWithBoldStyle(
                              //
                              saveSnapshotValue2[i]['name'].toString(),
                              //
                              Colors.black,
                              18.0,
                            ),
                            subtitle: textWithRegularStyle(
                              //
                              // '\u{20B9} ${saveSnapshotValue2[i]['total_count']}',
                              '$indianRupeeSymbol ${NumberFormat('#,##,000').format(
                                int.parse(
                                  saveSnapshotValue2[i]['total_count'],
                                ),
                              )}',
                              //
                              Colors.black,
                              14.0,
                            ),
                            //
                            trailing: const Icon(
                              Icons.chevron_right,
                              size: 18.0,
                            ),
                          ),
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
                      ],
                      /*Container(
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
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //
                              textWithBoldStyle(
                                '\u{20B9} ${saveSnapshotValue2.first['total_count'].toString()}',
                                Colors.black,
                                32.0,
                              ),
                            ],
                          ),
                        ),*/
                      //
                      //

                      //
                      //
                      //
                      /*const SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
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
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            child: Center(
                              child: textWithBoldStyle(
                                'History',
                                Colors.white,
                                16.0,
                              ),
                            ),
                          ),
                        ),*/
                      //
                      //
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
