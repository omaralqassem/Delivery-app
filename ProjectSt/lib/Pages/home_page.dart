import 'package:flutter/material.dart';
import '../Pages/store_page.dart';
import '../components/my_drawer.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

List<Map<String, dynamic>> allProducts = [];
List<String> storeNames = [];
List<int> storeId = [];
List<String> storesImages = [];
final TextEditingController _searchController = TextEditingController();
List<dynamic> sales = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool isLoading = true;
  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      fetchStores();
      fetchAndSortProducts();
      fetchProductsSales();
    });
  }

  Future<void> fetchProductsSales() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/products/sales');
    try {
      final response = await http.get(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);

        final List<dynamic> store = json.decode(response.body);
        setState(() {
          sales = store;
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

  Future<void> fetchStores() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/stores'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(response.body);
        setState(() {
          storeId = data.map((store) => store['id'] as int).toList();
          storeNames = data.map((store) => store['name'] as String).toList();
          storesImages = data.map((store) => store['image'] as String).toList();
          isLoading = false;
        });
        print(storesImages);
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching stores: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> selectedProducts = [];

  Future<void> fetchAndSortProducts() async {
    allProducts = [];

    try {
      for (int storeId in storeId) {
        final response = await http
            .get(Uri.parse('http://10.0.2.2:8000/api/stores/$storeId'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> storeData = json.decode(response.body);
          final List<dynamic> products = storeData['products'];
          allProducts.addAll(
              products.map((product) => product as Map<String, dynamic>));
        }
      }

      allProducts
          .sort((a, b) => (b['stock'] as int).compareTo(a['stock'] as int));

      setState(() {
        selectedProducts = allProducts.take(6).toList();
      });
    } catch (e) {
      print("Error fetching and sorting products: $e");
    }
  }

  static Future<Iterable<String>> searchStores(String query) async {
    await Future<void>.delayed(Duration(seconds: 1)); // Fake 1 second delay.
    if (query == '') {
      return const Iterable<String>.empty();
    }
    return storeNames.where((String option) {
      return option.contains(query);
    });
  }

  static Future<Iterable<Object>> searchProdcuts(String query) async {
    await Future<void>.delayed(Duration(seconds: 1)); // Fake 1 second delay.
    if (query == '') {
      return const Iterable<String>.empty();
    }
    return allProducts.where((product) {
      return product['name'].contains(query);
    });
  }

  String? _searchingWithQuery;

  @override
  void initState() {
    fetchStores();
    fetchAndSortProducts();
    fetchProductsSales();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(storesImages);

    return Scaffold(
        drawer: const MyDrawer(),
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SearchAnchor.bar(
                    viewLeading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    barElevation: WidgetStatePropertyAll(2),
                    suggestionsBuilder: (context, controller) async {
                      _searchingWithQuery = controller.text;
                      final List<String> options =
                          (await searchStores(_searchingWithQuery!)).toList();
                      final List<Object> optionsP =
                          (await searchProdcuts(_searchingWithQuery!)).toList();
                      List bruh = [];
                      bruh.addAll(optionsP);
                      return [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Stores:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        for (int i = 0; i < options.length; i++)
                          ListTile(
                            title: Text(options[i]),
                            onTap: () {
                              controller.closeView(null);
                              controller.clear();
                              controller.clearComposing();
                              int index = storeNames.indexOf(options[i]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StorePage(
                                    storeName: storeNames[index],
                                    storeId: storeId[index],
                                    storeImage: storesImages[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'Products:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        for (int i = 0; i < optionsP.length; i++)
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
                    barHintText: S.of(context).HPSearch,
                    barLeading: IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.menu)),
                    barTrailing: [
                      IconButton(
                          icon: Icon(Icons.shopping_bag_outlined),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/delivery'))
                    ],
                    keyboardType: TextInputType.text,
                  ),
                ),
                floating: true,
              ),
            ];
          },
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: ListView(padding: const EdgeInsets.all(0), children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).HPH1,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: storeNames.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: GestureDetector(
                                  child: Card(
                                    color: Color.fromARGB(207, 227, 255, 151),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  width: constraints.maxHeight,
                                                  height: constraints.maxHeight,
                                                  decoration: BoxDecoration(
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          spreadRadius: 1,
                                                          blurRadius: 5)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                          'http://10.0.2.2:8000/storage/${storesImages[index]}',
                                                        ),
                                                        fit: BoxFit.fill),
                                                  ),
                                                  // child: Image.network(
                                                  //   'http://10.0.2.2:8000/storage/${storesImages[index]}',
                                                  //   fit: BoxFit.cover,
                                                  // ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StorePage(
                                          storeName: storeNames[index],
                                          storeId: storeId[index],
                                          storeImage: storesImages[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).HPH2,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 400,
                          child: selectedProducts.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : GridView.builder(
                                  padding: const EdgeInsets.all(0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  itemCount: selectedProducts.length,
                                  itemBuilder: (context, index) {
                                    final product = selectedProducts[index];
                                    return GestureDetector(
                                      onTap: () {
                                        showbottomsheet(context, product);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Card(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 15.0),
                                                    height: 140.0,
                                                    width: 150.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12.0),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          product['image'] !=
                                                                      null &&
                                                                  product['image']
                                                                      .isNotEmpty
                                                              ? "http://10.0.2.2:8000/storage/${product['image']}"
                                                              : 'assets/images/placeholder.jpg',
                                                        ),
                                                        fit: BoxFit.contain,
                                                      ),
                                                      shape: BoxShape.rectangle,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      product['name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text(
                                                      "\$${product['price']}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            S.of(context).HPH3,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(
                          height: 400,
                          child: GridView.builder(
                            padding: const EdgeInsets.all(0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            scrollDirection: Axis.vertical,
                            itemCount: sales!.length,
                            itemBuilder: (context, index) {
                              final saless = sales![index];
                              print(saless);
                              return GestureDetector(
                                onTap: () {
                                  showbottomsheet(context, saless);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 15.0),
                                            height: 140.0,
                                            width: 150.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  saless['image'] != null &&
                                                          saless['image']
                                                              .isNotEmpty
                                                      ? "http://10.0.2.2:8000/storage/${saless['image']}"
                                                      : 'assets/images/placeholder.jpg',
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                              shape: BoxShape.rectangle,
                                            ),
                                          ),
                                          Positioned(
                                            top: 12,
                                            left: 12,
                                            child: Container(
                                              padding: EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      156, 255, 235, 59),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: ClipRRect(
                                                child: Text(
                                                  '${saless['sales_percentage']}%',
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Column(
                                          children: [
                                            Text(
                                              "${saless['name']}",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "${saless['price']}\$  ->  ${saless['price_after_sales']}\$",
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
                        const SizedBox(
                          height: 500,
                        ),
                      ],
                    ),
                  ]),
                ),
        ));
  }
}
