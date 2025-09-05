import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

final productsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>(
    (ref, storeId) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/stores/$storeId'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> products = data['products'];
    return products
        .map((product) => {
              'id': product['id'],
              'name': product['name'],
              'description': product['description'],
              'price': product['price'],
              'stock': product['stock'],
              'popularity': product['popularity'],
              'image': product['image'] ?? ''
            })
        .toList();
  } else {
    throw Exception('Failed to load products');
  }
});
