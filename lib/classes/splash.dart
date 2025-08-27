// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myself_diary/classes/utilities/APIs/helper.dart';
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
  String saveSelectedCategoryId = '';

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

    if (title.isEmpty || amount.isEmpty || saveSelectedCategoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields (including Category)"),
        ),
      );
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
    final selected = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  "Select Category",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),

                FutureBuilder<List<Map<String, dynamic>>>(
                  future: ApiService().getCategories(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snap.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          children: [
                            Text(
                              "Failed to load categories:\n${snap.error}",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      );
                    }

                    final cats = snap.data ?? [];
                    if (cats.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text("No categories found"),
                      );
                    }

                    return Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: cats.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final c = cats[index];
                          final id = (c['id'] as num).toInt();
                          final name = c['name']?.toString() ?? 'Unnamed';
                          final iconName = c['icon_name']?.toString();

                          return ListTile(
                            leading: Icon(mapIcon(iconName), size: 20),
                            title: Text(name),
                            onTap: () {
                              Navigator.pop<Map<String, dynamic>>(context, {
                                "id": id,
                                "name": name,
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _categoriesController.text = selected["name"].toString(); // show name
        saveSelectedCategoryId = selected["id"].toString(); // keep ID
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
      category: saveSelectedCategoryId,
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
      _titleController.clear();
      _amountController.clear();
      _descriptionController.clear();
      _categoriesController.clear();
      saveSelectedCategoryId = '';
      _fetchTotal();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(submitRes["alertMessage"].toString())),
      );
    }
    // print(totalRes);
  }
}
