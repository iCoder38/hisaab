import 'package:flutter/material.dart';

IconData mapIcon(String? iconName) {
  switch (iconName) {
    case 'shopping_cart':
      return Icons.shopping_cart;
    case 'restaurant':
      return Icons.restaurant;
    case 'directions_car':
      return Icons.directions_car;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'school':
      return Icons.school;
    case 'account_balance_wallet':
      return Icons.account_balance_wallet;
    case 'more_horiz':
      return Icons.more_horiz;
    default:
      return Icons.category; // fallback
  }
}
