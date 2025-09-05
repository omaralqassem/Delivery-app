import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String _baseUrl = '';
  static const String _addFavoriteEndpoint = '';

  static Future<void> addToCart({
    required int product_id,
    required int quantity,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      debugPrint('Auth Token: $authToken');

      if (authToken == null) {
        debugPrint('Auth token is null. User might not be logged in.');
        return;
      }

      final url = Uri.parse('http://10.0.2.2:8000/api/carts/add-item');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'product_id': product_id,
          'quantity': quantity,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Item added to cart successfully!');
      } else {
        debugPrint('Failed to add item to cart: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');

        if (response.headers['content-type']?.contains('text/html') ?? false) {
          debugPrint('Received HTML response. Likely an error page.');
        }
      }
    } catch (e) {
      debugPrint('Error adding item to cart: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      if (authToken == null) {
        debugPrint('Auth token is null');
        return [];
      }
      final url = Uri.parse('http://10.0.2.2:8000/api/carts');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> items = responseBody['items'];

        final List<Map<String, dynamic>> cartItems = items.map((item) {
          final Map<String, dynamic> product = item['product'];
          print(product);
          return {
            'id': item['id'],
            'name': product['name'],
            'description': product['description'],
            'price': product['price_after_sales'] != null
                ? product['price_after_sales']
                : product['price'],
            'image': product['image'],
            'quantity': item['quantity'],
            'total_price': item['total_price'],
          };
        }).toList();
        print(response.statusCode);
        print(cartItems);
        return cartItems;
      } else {
        debugPrint('Failed to fetch cart: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching cart: $e');
      return [];
    }
  }

  static Future<bool> removeFromCart({
    required int productId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      final url =
          Uri.parse('http://10.0.2.2:8000/api/carts/remove-item/$productId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Item removed from cart successfully!');
        return true;
      } else {
        debugPrint('Failed to remove item from cart: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Error removing item from carts: $e');
      return false;
    }
  }
}
