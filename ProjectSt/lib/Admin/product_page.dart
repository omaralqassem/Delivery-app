import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projectst/Admin/productProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> addProduct(
  int storeId,
  String name,
  String description,
  int stock,
  double price,
  WidgetRef ref,
  BuildContext context,
) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/products?store_id=$storeId');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'description': description,
      'stock': stock,
      'price': price,
    }),
  );

  if (response.statusCode == 201) {
    ref.refresh(productsProvider(storeId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product added successfully'),
      ),
    );
  } else {
    throw Exception('Failed to add product: ${response.statusCode}');
  }
}

Future<void> deleteProduct(
    int storeId, int productId, WidgetRef ref, BuildContext context) async {
  try {
    final storeResponse =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/stores/$storeId'));

    if (storeResponse.statusCode != 200) {
      throw Exception(
          'Failed to fetch store data: ${storeResponse.statusCode}');
    }

    final Map<String, dynamic> storeData = json.decode(storeResponse.body);

    final List<dynamic> products = storeData['products'];
    products.removeWhere((product) => product['id'] == productId);

    final updateResponse = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/stores/$storeId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(storeData),
    );

    if (updateResponse.statusCode == 200) {
      ref.refresh(productsProvider(storeId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product deleted successfully'),
        ),
      );
    } else {
      throw Exception('Failed to update store: ${updateResponse.statusCode}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete product: $e'),
      ),
    );
  }
}

class ProductPage extends ConsumerWidget {
  final int storeId;

  const ProductPage({super.key, required this.storeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsyncValue = ref.watch(productsProvider(storeId));

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddProductDialog(context, ref, storeId),
          ),
        ],
        title: Text('Products'),
      ),
      body: productsAsyncValue.when(
        data: (products) {
          if (products.isEmpty) {
            return Center(
              child: Text('There are no products for this store.'),
            );
          }
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.asset(
                    'assets/photos/airj.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product['description']),
                      Text('Price: \$${product['price']}'),
                      Text('Stock: ${product['stock']}'),
                    ],
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      await deleteProduct(storeId, product['id'], ref, context);
                    },
                    icon: Icon(
                      Icons.delete,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

Future<void> _showAddProductDialog(
    BuildContext context, WidgetRef ref, int storeId) async {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final stockController = TextEditingController();
  final priceController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Product'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: stockController,
              decoration: InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text;
              final description = descriptionController.text;
              final stock = int.tryParse(stockController.text) ?? 0;
              final price = double.tryParse(priceController.text) ?? 0.0;

              if (name.isNotEmpty && description.isNotEmpty) {
                try {
                  await addProduct(
                      storeId, name, description, stock, price, ref, context);
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add product: $e'),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill all fields'),
                  ),
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}
