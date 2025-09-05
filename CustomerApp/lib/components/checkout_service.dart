import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../components/cart.dart';

class CheckoutService {
  static bool ckeckedOut = false;
  static double total = 0.0;

  static Future<void> getTotal() async {
    try {
      final carts = await CartService.getCart();
      total = carts.fold(0.0, (sum, item) {
        return sum + double.parse(item['total_price']);
      });
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    }
  }

  static Future<void> checkout({
    String? delivery_time,
    required String? payment_method,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      debugPrint('Auth Token: $authToken');

      if (authToken == null) {
        debugPrint('Auth token is null. User might not be logged in.');
      }

      final url = Uri.parse('http://10.0.2.2:8000/api/carts/checkout');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'address': "meow dow",
          'pay_with': payment_method,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Chcked out successfully!');
        ckeckedOut = true;
        final url = Uri.parse('http://10.0.2.2:8000/api/carts/clear');
        final response = await http.delete(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );
      } else {
        debugPrint('Failed to checkout: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');

        if (response.headers['content-type']?.contains('text/html') ?? false) {
          debugPrint('Received HTML response. Likely an error page.');
        }
        ckeckedOut = false;
      }
    } catch (e) {
      debugPrint('Error checking out: $e');
      ckeckedOut = false;
    }
  }
}
