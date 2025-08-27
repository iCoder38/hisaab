// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myself_diary/classes/utilities/APIs/service.dart';
import 'package:myself_diary/classes/utilities/app_utilities/extenstion.dart';
import 'package:myself_diary/classes/utilities/app_utilities/utils.dart';
import 'package:myself_diary/classes/utilities/custom/app_drawer.dart';
import 'package:myself_diary/classes/utilities/custom/text.dart';
import 'package:myself_diary/classes/utilities/firebase/auth.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  // firebase auth state
  Stream<User?> authStateChanges = FirebaseAuth.instance.authStateChanges();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String totalSpent = '';

  String uid = '';

  // Categories Array
  final List<Map<String, dynamic>> categories = [
    {"name": "Grocery & Household", "icon": Icons.shopping_cart},
    {"name": "Food & Dining", "icon": Icons.restaurant},
    {"name": "Transport & Travel", "icon": Icons.directions_car},
    {"name": "Shopping & Entertainment", "icon": Icons.shopping_bag},
    {"name": "Health & Personal Care", "icon": Icons.health_and_safety},
    {"name": "Education & Work", "icon": Icons.school},
    {"name": "Bills & Finance", "icon": Icons.account_balance_wallet},
    {"name": "Others / Miscellaneous", "icon": Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();

    // first check is this user logged in?
    checkUserLoginStatus(context);
  }

  checkUserLoginStatus(context) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user == null) {
        debugPrint('🔴 User is currently signed out!');
        showAuthSheet(context);
      } else {
        debugPrint('🟢 User is signed in! UID: ${user.uid}');
        uid = user.uid.toString();
        await Future.delayed(Duration(milliseconds: 400));
        _fetchTotal();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _categoriesController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) async {
    final title = _titleController.text.trim();
    final amount = _amountController.text.trim();
    // final description = _descriptionController.text.trim();
    final category = _categoriesController.text.trim();

    if (title.isEmpty || amount.isEmpty || category.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }
    context.dismissKeyboard();
    await Future.delayed(const Duration(milliseconds: 400));
    callSubmitPurchaseWB(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText("Home", fontSize: 18)),
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

            // Category field
            TextField(
              readOnly: true,
              controller: _categoriesController,
              onTap: _showCategoryDropdown,
              decoration: InputDecoration(
                labelText: "Categories",
                prefixIcon: const Icon(Icons.category),
                suffixIcon: const Icon(Icons.arrow_drop_down),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
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

  void _showCategoryDropdown() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(categories[index]["icon"], color: Colors.blue),
              title: Text(categories[index]["name"]),
              onTap: () {
                Navigator.pop(context, categories[index]["name"]);
              },
            );
          },
        );
      },
    );
    if (selected != null) {
      setState(() {
        _categoriesController.text = selected;
      });
    }
  }

  // ===================================
  // ============ FETCH TOTAL AMOUNT API
  // ===================================
  Future<void> _fetchTotal() async {
    try {
      final totalRes = await ApiService().getTotalPurchase(uid);
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
      userId: uid,
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
      // clear fields
      _titleController.text = "";
      _amountController.text = "";
      _descriptionController.text = "";
      _fetchTotal();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(submitRes["alertMessage"].toString())),
      );
    }
    // print(totalRes);
  }
}
