import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myself_diary/classes/utilities/APIs/service.dart';
import 'package:myself_diary/classes/utilities/custom/app_drawer.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String totalSpent = '';

  @override
  void initState() {
    super.initState();
    _fetchTotal();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    final title = _titleController.text.trim();
    final amount = _amountController.text.trim();
    final description = _descriptionController.text.trim();

    if (title.isEmpty || amount.isEmpty || description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    callSubmitPurchaseWB(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Splash Screen")),
      drawer: const AppDrawer(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // amber container
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  totalSpent,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Title field
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Title",
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Amount field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description field
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Description",
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _handleSubmit(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================
  // ============ FETCH TOTAL AMOUNT API
  // ===================================
  Future<void> _fetchTotal() async {
    try {
      final api = ApiService();
      final totalRes = await api.getTotalPurchase("1");
      final total = totalRes['total_spent'].toString();

      setState(() {
        totalSpent = total;
      });
    } catch (e) {
      setState(() {
        totalSpent = "Error: $e";
      });
    }
  }

  // ===================================
  // ============ SUBMIT API
  // ===================================
  callSubmitPurchaseWB(context) async {
    final api = ApiService();

    // Insert purchase
    final submitRes = await api.submitPurchase(
      userId: "1",
      title: _titleController.text.toString(),
      amount: _amountController.text.toString(),
      description: _descriptionController.text.toString(),
    );

    // Get total
    //final totalRes = await api.getTotalPurchase("1");
    print(""" 
    ============================================================
    RESPONSE: $submitRes
    ============================================================
    """);
    if (submitRes["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(submitRes["alertMessage"].toString())),
      );
      _fetchTotal();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(submitRes["alertMessage"].toString())),
      );
    }
    // print(totalRes);
  }
}
