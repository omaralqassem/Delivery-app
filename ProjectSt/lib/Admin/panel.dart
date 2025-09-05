import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projectst/Admin/storesProvider.dart';
import '../Admin/product_page.dart';
import 'package:http/http.dart' as http;

Future<void> addStore(String name, String address, String phone) async {
  final url = Uri.parse('http://127.0.0.1:8000/api/stores');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'name': name,
      'address': address,
      'phone_number': phone,
    }),
  );
  if (response.statusCode == 201) {
    print('Store added successfully');
  } else {
    throw Exception('Failed to add store: ${response.statusCode}');
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
                        child: Image.asset(
                          'assets/photos/airj.png',
                          fit: BoxFit.cover,
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
                                  await deleteStore(
                                      storeId); // Call the delete function with the store ID
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

              if (name.isNotEmpty && address.isNotEmpty && phone.isNotEmpty) {
                try {
                  await addStore(name, address, phone);
                  ref.refresh(storesProvider);
                  Navigator.of(context).pop();
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
