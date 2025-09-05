import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/stores'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((store) => {
              'id': store[
                  'id'], // Ensure your API response includes an 'id' field
              'name': store['name'].toString(),
              'image': store['image']
            })
        .toList();
  } else {
    throw Exception('Failed to load stores');
  }
});
