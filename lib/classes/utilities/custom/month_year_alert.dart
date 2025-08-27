import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Show a Cupertino-style month-year picker bottom sheet.
/// Returns: Map {"month": int, "year": int}
Future<Map<String, int>?> showMonthYearPickerSheet(
  BuildContext context, {
  int? initialMonth,
  int? initialYear,
  int startYear = 2000,
  int endYear = 2100,
}) async {
  final months = List<String>.generate(12, (i) {
    return [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ][i];
  });

  final years = List<int>.generate(
    endYear - startYear + 1,
    (i) => startYear + i,
  );

  int selectedMonth = initialMonth ?? DateTime.now().month;
  int selectedYear = initialYear ?? DateTime.now().year;

  return showModalBottomSheet<Map<String, int>>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) {
      return SizedBox(
        height: 300,
        child: Column(
          children: [
            // Header with Done button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.5),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Select Month & Year",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx, {
                        "month": selectedMonth,
                        "year": selectedYear,
                      });
                    },
                    child: const Text("Done"),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Row(
                children: [
                  // Month picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedMonth - 1,
                      ),
                      itemExtent: 40,
                      magnification: 1.1,
                      useMagnifier: true,
                      onSelectedItemChanged: (index) {
                        selectedMonth = index + 1;
                      },
                      children: months
                          .map((m) => Center(child: Text(m)))
                          .toList(),
                    ),
                  ),
                  // Year picker
                  Expanded(
                    child: CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                        initialItem: years.indexOf(selectedYear),
                      ),
                      itemExtent: 40,
                      magnification: 1.1,
                      useMagnifier: true,
                      onSelectedItemChanged: (index) {
                        selectedYear = years[index];
                      },
                      children: years
                          .map((y) => Center(child: Text(y.toString())))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
