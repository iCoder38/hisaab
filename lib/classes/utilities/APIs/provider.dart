import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myself_diary/classes/utilities/APIs/service.dart';

/// ✅ Provide ApiService
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// provider.dart
// final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
typedef PurchaseQuery = ({
  String userId,
  int? month,
  int? year,
  int page,
  int limit,
});

// Now returns Map<String, dynamic>, not List
final purchasesProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, PurchaseQuery>((ref, q) async {
      final api = ref.read(apiServiceProvider);
      return api.getPurchases(
        q.userId,
        month: q.month,
        year: q.year,
        page: q.page,
        limit: q.limit,
      );
    });

/// ===============================
///         CATEGORIES
/// ===============================

/// ✅ Fetch all categories from API
/// Returns: List of maps like: [{'id': 1, 'name': 'Food & Dining'}, ...]
final categoriesProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final api = ref.read(apiServiceProvider);
      return api.getCategories();
    });

/// ✅ Hold currently-selected category ID (int?) and name (String?)
final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);
final selectedCategoryNameProvider = StateProvider<String?>((ref) => null);
