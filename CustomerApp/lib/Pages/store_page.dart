import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/cart.dart';
import '../components/favourites.dart';
import 'dart:convert';
import '../generated/l10n.dart';

bool isFavorited = false;
bool isCarted = false;
List<dynamic> allProducts = [];

class StorePage extends StatefulWidget {
  final String storeName;
  final int storeId;
  final String storeImage;

  const StorePage({
    super.key,
    required this.storeName,
    required this.storeId,
    required this.storeImage,
  });

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  bool isLoading = true;

  @override
  void initState() {
    fetchProducts();
    super.initState();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/stores/${widget.storeId}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> store = json.decode(response.body);
        setState(() {
          allProducts = store['products'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $e');
    }
  }

  static Future<Iterable<dynamic>> searchProducts(String query) async {
    await Future<void>.delayed(Duration(seconds: 1)); // Fake 1 second delay.
    if (query == '') {
      return const Iterable<String>.empty();
    }
    return allProducts.where((option) {
      return option['name'].contains(query);
    });
  }

  String? _searchingWithQuery;

  @override
  Widget build(BuildContext context) {
    String img = widget.storeImage;
    print('img $img');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: SearchAnchor.bar(
          barElevation: WidgetStatePropertyAll(2),
          suggestionsBuilder: (context, controller) async {
            _searchingWithQuery = controller.text;
            final List<dynamic> options =
                (await searchProducts(_searchingWithQuery!)).toList();
            List bruh = [];
            bruh.addAll(options);
            return [
              for (int i = 0; i < options.length; i++)
                ListTile(
                  title: Text(bruh[i]['name']),
                  onTap: () {
                    controller.closeView(null);
                    controller.clear();
                    controller.clearComposing();
                    showbottomsheet(context, bruh[i]);
                  },
                ),
            ];
          },
          viewLeading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          barHintText: S.of(context).StoreSearch,
          barLeading: IconButton(
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios)),
          keyboardType: TextInputType.text,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xffB6D0BC),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
              child: Image.network(
                'http://10.0.2.2:8000/storage/${widget.storeImage}',
                fit: BoxFit.fill, // Use BoxFit.cover to fill the container
              ),
            ),
          ),
          ListTile(
            title: Text(
              widget.storeName,
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StarRating(
                  rating: 2.5,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text('44'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              S.of(context).HPH2,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : allProducts.isEmpty
                    ? const Center(
                        child: Text('There are no products in this store.'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            allProducts.length, // Use the length of allProducts
                        itemBuilder: (context, index) {
                          final product = allProducts[index];
                          return GestureDetector(
                            onTap: () {
                              showbottomsheet(
                                  context, product); // Pass product details
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Card.outlined(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 1.29,
                                        child: Image.network(
                                          "http://10.0.2.2:8000/storage/${product['image']}",
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      children: [
                                        Text(
                                          product['name'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "\$${product['price']}",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final int starCount = 5;
  final double rating;
  final Color color = const Color(0xffB6D0BC);

  StarRating({super.key, this.rating = .0});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border,
        color: Color(0xffF8FFF8),
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
      );
    }
    return InkResponse(
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        children:
            List.generate(starCount, (index) => buildStar(context, index)));
  }
}

void showbottomsheet(BuildContext context, Map<String, dynamic> product) {
  int selectedQuantity = 1;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (cntx) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product image
                  Image.network(
                    product['image'] != null && product['image'].isNotEmpty
                        ? "http://10.0.2.2:8000/storage/${product['image']}"
                        : 'assets/images/placeholder.jpg',
                    height: MediaQuery.of(context).size.width / 2,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 15.0),
                  Center(
                    child: Text(
                      product['name'], // Product name
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 23.0),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    child: Text(
                      product['description'], // Product description
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 5.0),
                        child: product['price_after_sales'] != null
                            ? Text(
                                'Price: \$${product['price_after_sales']}', // Product price
                                style: const TextStyle(fontSize: 16.0),
                              )
                            : Text(
                                'Price: \$${product['price']}', // Product price
                                style: const TextStyle(fontSize: 16.0),
                              )),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 5.0),
                      child: Text(
                        'Stock: ${product['stock']}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Quantity: ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      DropdownButton<int>(
                        value: selectedQuantity,
                        onChanged: (int? newValue) {
                          setState(() {
                            selectedQuantity = newValue!;
                          });
                        },
                        items: List.generate(
                                product['stock'], (index) => index + 1)
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: FloatingActionButton.extended(
                          onPressed: isFavorited
                              ? null
                              : () {
                                  isFavorited = true;
                                  FavoritesService.addToFavorites(
                                      product_id: product['id']);
                                },
                          label: Text(S.of(context).PDF),
                          icon: const Icon(Icons.favorite),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 20,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            isCarted = true;
                            CartService.addToCart(
                              product_id: product['id'],
                              quantity: selectedQuantity,
                            );

                            // Close the bottom sheet
                            Navigator.pop(context);
                          },
                          label: Text(S.of(context).PDC),
                          icon: const Icon(Icons.shopping_cart),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0), // Add extra space at the bottom
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
