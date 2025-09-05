import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _baseUrl = 'http://10.0.2.2:8000/api';
  static const String _addFavoriteEndpoint = '/favorites/add-item';

  static Future<void> addToFavorites({
    required int product_id,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      final url = Uri.parse('$_baseUrl$_addFavoriteEndpoint');
      print(authToken);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'product_id': product_id,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Item added to favorites successfully!');
      } else {
        debugPrint('Failed to add item to favorites: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error adding item to favorites: $e');
    }
  }

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      final url = Uri.parse('http://10.0.2.2:8000/api/favorites');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        final List<dynamic> favorites = responseBody['favorites'];
        print(responseBody);
        return favorites.map((item) {
          return {
            'id': item['id'],
            'name': item['name'],
            'description': item['description'],
            'price': item['price'],
            'stock': item['stock'],
            'image': item['image'],
          };
        }).toList();
      } else {
        debugPrint('Failed to fetch favorites: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
      return [];
    }
  }

  static Future<bool> removeFromFavorites({
    required int productId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? authToken = prefs.getString('authToken');
      final url = Uri.parse(
          'http://10.0.2.2:8000/api/favorites/remove-item/$productId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Item removed from favorites successfully!');
        return true; // Success
      } else {
        debugPrint(
            'Failed to remove item from favorites: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false; // Failure
      }
    } catch (e) {
      debugPrint('Error removing item from favorites: $e');
      return false; // Failure
    }
  }
}
