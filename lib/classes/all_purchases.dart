import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myself_diary/classes/utilities/APIs/provider.dart';
import 'package:myself_diary/classes/utilities/custom/app_drawer.dart';
import 'package:myself_diary/classes/utilities/custom/methods.dart';
import 'package:myself_diary/classes/utilities/custom/month_year_alert.dart';
import 'package:myself_diary/classes/utilities/custom/text.dart';
import 'package:myself_diary/classes/widgets/all_purchases.dart';

class GetAllPurchasesScreen extends ConsumerStatefulWidget {
  const GetAllPurchasesScreen({super.key, this.userId = "1"});
  final String userId;

  @override
  ConsumerState<GetAllPurchasesScreen> createState() =>
      _GetAllPurchasesScreenState();
}

class _GetAllPurchasesScreenState extends ConsumerState<GetAllPurchasesScreen> {
  int? selectedMonth;
  int? selectedYear;

  String totalSpend = '';

  PurchaseQuery _query() => (
    userId: widget.userId,
    month: selectedMonth,
    year: selectedYear,
    page: 1,
    limit: 50,
  );

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(purchasesProvider(_query()));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Purchases"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await ref.refresh(purchasesProvider(_query()).future);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showMonthYearPickerSheet(context);
              if (result != null) {
                setState(() {
                  selectedMonth = result["month"];
                  selectedYear = result["year"];
                });
                await ref.refresh(purchasesProvider(_query()).future);
              }
            },
          ),
          if (selectedMonth != null && selectedYear != null)
            IconButton(
              tooltip: 'Clear filter',
              icon: const Icon(Icons.clear_all),
              onPressed: () async {
                setState(() {
                  selectedMonth = null;
                  selectedYear = null;
                });
                await ref.refresh(purchasesProvider(_query()).future);
              },
            ),
        ],
      ),
      drawer: const AppDrawer(),
      body: purchasesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Error: $e"),
          ),
        ),
        data: (resp) {
          // resp is Map<String, dynamic>
          final List<Map<String, dynamic>> items =
              (resp['purchases'] as List? ?? [])
                  .whereType<Map>()
                  .map((e) => Map<String, dynamic>.from(e))
                  .toList();

          // monthly total (server se)
          final String totalSpend = (resp['total_spends_filtered'] ?? 0)
              .toString();

          // (optional) strict client-side month/year filter
          List<Map<String, dynamic>> filtered = items;
          if (selectedMonth != null && selectedYear != null) {
            DateTime? parseUtc(String s) {
              if (s.isEmpty) return null;
              final iso = DateTime.tryParse(s);
              if (iso != null) return iso.toUtc();
              return DateTime.tryParse('${s.replaceAll(' ', 'T')}Z')?.toUtc();
            }

            filtered = items.where((m) {
              final ts = (m['created_at'] ?? '').toString();
              final dt = parseUtc(ts);
              return dt != null &&
                  dt.month == selectedMonth &&
                  dt.year == selectedYear;
            }).toList();
          }

          if (filtered.isEmpty) {
            return const Center(child: Text("No purchases yet."));
          }

          // totalSpend ko top header me dikhao
          return _UIKIT(filtered, totalSpend);
        },
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _UIKIT(List<Map<String, dynamic>> items, ts) {
    // (optional) if you have selectedMonth/Year in this State, show them:
    String? monthText;
    if (mounted) {
      // Only if you added selectedMonth/selectedYear in your State earlier:
      try {
        // ignore: unnecessary_this
        final st = this;
        final sm = (st as dynamic).selectedMonth as int?;
        final sy = (st as dynamic).selectedYear as int?;
        if (sm != null && sy != null) {
          const months = [
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
          ];
          monthText = "${months[sm - 1]} $sy";
        }
      } catch (_) {}
    }

    return Column(
      children: [
        // 🔹 Fixed header (won’t scroll)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widgetHeaderPurchaseDetails(context, items, monthText, ts),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 🔹 Scrollable list with pull-to-refresh
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              // ignore: unused_result
              await ref.refresh(purchasesProvider(_query()).future);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final id = item['id']?.toString() ?? '-';
                final title = item['title']?.toString() ?? '(no title)';
                final amount = item['amount']?.toString() ?? '0';
                final desc = item['description']?.toString() ?? '';
                final createdAt = item['created_at']?.toString() ?? '';

                return widgetCardUIKIT(id, title, desc, createdAt, amount);
              },
            ),
          ),
        ),
      ],
    );
  }
}
