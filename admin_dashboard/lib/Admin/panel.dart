import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:admin_dashboard/Admin/storesProvider.dart';
import '../Admin/product_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:image_picker_web/image_picker_web.dart';

Future<void> addStore(
  String name,
  String address,
  String phone,
  Uint8List? imageBytes,
) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/stores');

  var request = http.MultipartRequest('POST', url);

  request.fields['name'] = name;
  request.fields['address'] = address;
  request.fields['phone_number'] = phone;

  if (imageBytes != null) {
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'store_image.jpg',
      ),
    );
  }

  var response = await request.send();

  if (response.statusCode == 201) {
    print('Store added successfully');
  } else {
    throw Exception('Failed to add store: ${response.statusCode}');
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

Future<void> deleteStore(int storeId) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/stores/$storeId');
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    print('Store deleted successfully');
  } else {
    throw Exception('Failed to delete store: ${response.statusCode}');
  }
}

enum SideBarItem {
  stores(value: 'Stores', iconData: Icons.business, body: StoreScreen());

  const SideBarItem(
      {required this.value, required this.iconData, required this.body});
  final String value;
  final IconData iconData;
  final Widget body;
}

final sideBarItemProvider =
    StateProvider<SideBarItem>((ref) => SideBarItem.stores);

class PanelPage extends ConsumerWidget {
  const PanelPage({super.key});

  SideBarItem getSideBarItem(AdminMenuItem item) {
    for (var value in SideBarItem.values) {
      if (item.route == value.name) {
        return value;
      }
    }
    return SideBarItem.stores;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sideBarItem = ref.watch(sideBarItemProvider);
    return AdminScaffold(
        appBar: AppBar(title: const Text('Wasselha Admin Panel')),
        sideBar: SideBar(
            activeBackgroundColor: Colors.white,
            onSelected: (item) => ref
                .read(sideBarItemProvider.notifier)
                .update((state) => getSideBarItem(item)),
            items: SideBarItem.values
                .map((e) => AdminMenuItem(
                    title: e.value, icon: e.iconData, route: e.name))
                .toList(),
            selectedRoute: sideBarItem.name),
        body: sideBarItem.body);
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text('blabla'),
    );
  }
}

SideBarItem getSideBarItem(AdminMenuItem item) {
  for (var value in SideBarItem.values) {
    if (item.route == value.name) {
      return value;
    }
  }
  return SideBarItem.stores;
}

class StoreScreen extends ConsumerWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var screenSize = MediaQuery.of(context).size;
    final storesAsyncValue = ref.watch(storesProvider);

    return Column(
      children: [
        Container(
          child: Row(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Stores :",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)))),
                    onPressed: () => _showAddStoreDialog(context, ref),
                    child: Text("Add Store")))
          ]),
        ),
        SizedBox(
          width: double.infinity,
          height: screenSize.height / 1.2,
          child: storesAsyncValue.when(
            data: (stores) => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              scrollDirection: Axis.vertical,
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final store = stores[index];
                final storeName = store['name'];
                final storeId = store['id'];
                print(store['image']);
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(storeId: storeId),
                      ),
                    );
                  },
                  child: Card(
                      child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 300 / 250,
                        child: Image.network(
                          store['image'] != null && store['image'].isNotEmpty
                              ? "http://127.0.0.1:8000/storage/${store['image']}"
                              : 'assets/images/sneaker.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          scale: 1,
                        ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              storeName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacer(),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)))),
                              onPressed: () async {
                                try {
                                  await deleteStore(storeId);
                                  ref.refresh(
                                      storesProvider); // Refresh the store list
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '$storeName deleted successfully'),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Failed to delete $storeName: $e'),
                                    ),
                                  );
                                }
                              },
                              child: Text("Remove The store")),
                        ],
                      )
                    ],
                  )),
                );
              },
            ),
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }
}

Future<void> _showAddStoreDialog(BuildContext context, WidgetRef ref) async {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Store'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Store Name'),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                await getImage();
              },
              child: Text("Select Store Image"),
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
              final address = addressController.text;
              final phone = phoneController.text;

              if (name.isNotEmpty &&
                  address.isNotEmpty &&
                  phone.isNotEmpty &&
                  _fileBytes != null) {
                try {
                  await addStore(name, address, phone, _fileBytes);
                  ref.refresh(storesProvider); // Refresh the store list
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Store added successfully'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add store: $e'),
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
