import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../generated/l10n.dart';
import 'package:projectst/components/cart.dart';
import 'package:projectst/components/checkout_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartList = [];
  double totalCartPrice = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCART();
    CheckoutService.getTotal();
  }

  Future<void> fetchCART() async {
    try {
      final carts = await CartService.getCart();
      // print(carts);
      setState(() {
        cartList = carts;
        totalCartPrice = carts.fold(0.0, (sum, item) {
          return sum + double.parse(item['total_price']);
        });
      });
    } catch (e) {
      debugPrint('Error fetching cart: $e');
    }
  }

  Future<void> _removeCart(int productId, int index) async {
    final success = await CartService.removeFromCart(
      productId: productId,
    );

    if (success) {
      setState(() {
        totalCartPrice -= double.parse(cartList[index]['total_price']);
        cartList.removeAt(index);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item removed from cart!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item from cart.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        title: Text(S.of(context).CartTitle),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  '${S.of(context).CartH}${cartList.length}${S.of(context).CartH2}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Divider(thickness: 3, indent: 20, endIndent: 20),
          const SizedBox(height: 30),
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {
                var item = cartList[index];
                return Slidable(
                  key: ValueKey(item['id']),
                  endActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      backgroundColor: const Color(0xff2f2e2e),
                      icon: Icons.delete,
                      label: 'Delete',
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      onPressed: (BuildContext context) async {
                        await _removeCart(item['id'], index);
                        // print(item['id']);
                      },
                    ),
                  ]),
                  child: rowShoes(
                    item['name'],
                    item['description'],
                    item['price'],
                    item['image'],
                    item['quantity'],
                    item['total_price'],
                  ),
                );
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      S.of(context).CartTotal,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Text(S.of(context).CartTax),
                  ],
                ),
                Text(
                  "$totalCartPrice USD",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            height: 70,
            decoration: BoxDecoration(
              boxShadow: const [BoxShadow(spreadRadius: 1, blurRadius: 1)],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              width: 500,
              height: 70,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/payment');
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: S.of(context).CartCheck,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget rowShoes(
    String? name,
    String? description,
    String? price,
    String? image,
    int? quantity,
    String? totalPrice,
  ) {
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
                image:
                    NetworkImage('http://10.0.2.2:8000/storage/${image ?? ''}'),
                fit: BoxFit.contain,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Price: ${price ?? '0.00'} USD",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Quantity: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {},
                      ),
                      Text(
                        '${quantity ?? 0}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Text(
                    'Total: ${totalPrice ?? '0.00'} USD',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
