import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myself_diary/classes/utilities/APIs/resources.dart';

class ApiService {
  // 👇 Base URL yahin fix kar diya
  static final String _baseUrl = BaseURL().url;

  /// POST request (for submit_purchases.php)
  Future<Map<String, dynamic>> submitPurchase({
    required String userId,
    required String title,
    required String amount,
    required String description,
  }) async {
    final url = Uri.parse("$_baseUrl/submit_purchases.php");
    final body = {
      "userId": userId,
      "title": title,
      "amount": amount,
      "description": description,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to submit purchase: ${response.body}");
    }
  }

  /// POST request (for get_total_purchases.php)
  Future<Map<String, dynamic>> getTotalPurchase(String userId) async {
    final url = Uri.parse("$_baseUrl/get_total_purchases.php");
    final body = {"userId": userId};

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch total purchase: ${response.body}");
    }
  }

  /// ✅ Fetch purchases for a user (optionally filter by month/year + pagination)
  // service.dart
  Future<Map<String, dynamic>> getPurchases(
    String userId, {
    int? month,
    int? year,
    int page = 1,
    int limit = 20,
  }) async {
    final filtered = (month != null && year != null);

    final url = Uri.parse("$_baseUrl/get_purchases.php");

    final body = <String, dynamic>{
      "userId": userId,
      "page": page,
      "limit": limit,
      if (filtered) "month": month,
      if (filtered) "year": year,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to fetch purchases: HTTP ${response.statusCode} ${response.body}",
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['alertMessage'] ?? 'Failed to load purchases');
    }

    // ✅ return full map (outer fields + purchases)
    return data;
  }
}
