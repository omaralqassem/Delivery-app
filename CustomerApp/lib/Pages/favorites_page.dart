import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projectst/components/favourites.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../generated/l10n.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> wishlistItems = [];

  @override
  void initState() {
    super.initState();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    try {
      final favorites = await FavoritesService.getFavorites();
      setState(() {
        wishlistItems = favorites;
      });
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
    }
  }

  Future<void> _removeFavorite(int productId, int index) async {
    final success = await FavoritesService.removeFromFavorites(
      productId: productId,
    );

    if (success) {
      setState(() {
        wishlistItems.removeAt(index); // Remove the item from the list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item removed from favorites!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item from favorites.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(wishlistItems);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(S.of(context).FavTitle),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30.0, left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Wish List",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Divider(thickness: 3, indent: 20, endIndent: 20),
          const SizedBox(height: 30),
          Container(
            height: 650,
            child: ListView.builder(
              itemCount: wishlistItems.length,
              itemBuilder: (context, index) {
                var item = wishlistItems[index];
                return Slidable(
                  key: ValueKey(item['id'] ?? index),
                  endActionPane: ActionPane(motion: ScrollMotion(), children: [
                    SlidableAction(
                      flex: 2,
                      backgroundColor: Color(0xff2f2e2e),
                      icon: Icons.delete,
                      label: 'Delete',
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      onPressed: (BuildContext context) async {
                        await _removeFavorite(item['id'], index);
                      },
                    )
                  ]),
                  child: rowShoes(
                    item['name'],
                    item['description'],
                    item['price'],
                    item['stock'],
                    item['image'],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget rowShoes(
      String name, String descrption, String price, int stock, String picha) {
    return Card(
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15.0),
            height: 150.0,
            width: 150.0,
            decoration: BoxDecoration(
              boxShadow: const [BoxShadow(spreadRadius: 1, blurRadius: 5)],
              borderRadius: BorderRadius.circular(12.0),
              image: DecorationImage(
                image: NetworkImage('http://10.0.2.2:8000/storage/$picha'),
                fit: BoxFit.contain,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "description $descrption",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      "$price Dollar",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Stock $stock',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(height: 30)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
