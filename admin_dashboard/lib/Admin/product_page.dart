import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_dashboard/Admin/productProvider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:image_picker_web/image_picker_web.dart';

Future<void> addProduct(
  int storeId,
  String name,
  String description,
  int stock,
  double price,
  String sale,
  WidgetRef ref,
  Uint8List? imageBytes,
  BuildContext context,
) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/products?store_id=$storeId');

  var request = http.MultipartRequest('POST', url);

  request.fields['name'] = name;
  request.fields['description'] = description;
  request.fields['stock'] = stock.toString();
  request.fields['price'] = price.toString();
  request.fields['sales_percentage'] = sale as String;

  if (imageBytes != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'product_image.jpg',
      ),
    );
  }

  var response = await request.send();

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
    final response = await http.delete(
      Uri.parse(
          'http://127.0.0.1:8000/api/products/$productId/?store_id=$storeId'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      ref.refresh(productsProvider(storeId));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product deleted successfully'),
        ),
      );
    } else {
      throw Exception('Failed to delete product: ${response.statusCode}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to delete product: $e'),
      ),
    );
  }
}

Uint8List? _fileBytes;
Image? _imageWidget;
Future<void> getImage() async {
  final imageBytes = await ImagePickerWeb.getImageAsBytes();

  if (imageBytes != null) {
    _fileBytes = imageBytes;
    _imageWidget = Image.memory(imageBytes);
  } else {
    print('No image selected.');
  }
}

class ProductPage extends ConsumerWidget {
  final int storeId;

  ProductPage({super.key, required this.storeId});

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
              print(product['image']);

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  leading: Image.network(
                    product['image'] != null && product['image'].isNotEmpty
                        ? "http://127.0.0.1:8000/storage/${product['image']}"
                        : 'assets/images/placeholder.jpg', // Replace with your placeholder image path
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    scale: 1,
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
  final saleController = TextEditingController();

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
            TextField(
              controller: saleController,
              decoration: InputDecoration(labelText: 'Sale'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                await getImage();
              },
              child: Text("Select Product Image"),
            ),
            if (_fileBytes != null)
              Text(
                'Image selected',
                style: TextStyle(color: Colors.green),
              )
            else
              Text(
                'No image selected',
                style: TextStyle(color: Colors.red),
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
              final sales = saleController.text ?? "0";
              if (name.isNotEmpty && description.isNotEmpty) {
                if (_fileBytes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select an image'),
                    ),
                  );
                  return;
                }

                try {
                  await addProduct(storeId, name, description, stock, price,
                      sales, ref, _fileBytes, context);
                  Navigator.of(context).pop(); // Close the dialog
                } catch (e) {
                  print('Failed to add product: $e');
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
