import 'package:flutter/material.dart';
import 'package:myself_diary/classes/utilities/APIs/helper.dart';
import 'package:myself_diary/classes/utilities/custom/methods.dart';
import 'package:myself_diary/classes/utilities/custom/text.dart';

Widget widgetHeaderPurchaseDetails(
  context,
  List<Map<String, dynamic>> items,
  String? monthText,
  ts,
) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border(
        bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Purchases",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),

        // First row: count + month
        Row(
          children: [
            CustomText(
              "Total: ${items.length}",
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            if (monthText != null) ...[
              const SizedBox(width: 8),
              Icon(Icons.calendar_month, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              CustomText(
                monthText.toString(),
                fontSize: 13,
                color: Colors.grey,
              ),
            ],
          ],
        ),

        // Second row: total spends
        if (ts != null) ...[
          const SizedBox(height: 2),
          CustomText(
            "Total Spend: ₹$ts",
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ],
    ),
  );
}

// CARD
Card widgetCardUIKIT(
  int index,
  String id,
  String title,
  String desc,
  String createdAt,
  String amount,
  String categoryName,
  String categoryImage,
) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      leading: CircleAvatar(child: CustomText("${index + 1}")),
      title: CustomText(
        title,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        maxLines: 1,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (desc.isNotEmpty) const SizedBox(height: 4),
          CustomText(desc, fontSize: 12, maxLines: 4),
          const SizedBox(height: 4),
          // ============== CATEGORY ====================
          if (categoryName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(mapIcon(categoryImage), size: 16),
                SizedBox(width: 4),
                CustomText(categoryName, fontSize: 12, maxLines: 4),
              ],
            ),
            const SizedBox(height: 4),
          ],

          // ===================================================================
          if (createdAt.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: CustomText(formatDbUtcToLocal(createdAt), fontSize: 10),
            ),
        ],
      ),
      trailing: Text(
        "₹ $amount",
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
