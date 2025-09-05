import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'ParsingOrders.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderHist extends StatefulWidget {
  const OrderHist({Key? key}) : super(key: key);

  @override
  OrderHistory createState() => OrderHistory();
}

class OrderHistory extends State<OrderHist> {
  List<Orders> acOrders = [];
  List<Orders> pastOrders = [];
  @override
  void initState() {
    super.initState();
    fetchOrders();
    print(acOrders);
  }

  Future<void> fetchOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('authToken');

    if (authToken == null) {
      print('Token not found');
      return;
    }

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/orders/showCuAll'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<Orders> ordersList =
          data.map((orderJson) => Orders.fromJson(orderJson)).toList();

      setState(() {
        acOrders = ordersList
            .where((order) =>
                order.status == "pending" || order.status == "shipped")
            .toList();
        pastOrders =
            ordersList.where((order) => order.status == "completed").toList();
      });
    } else {
      print('Failed to load orders');
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
        title: Text(S.of(context).OrderHisT),
      ),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                S.of(context).ActivOr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            acOrders.isEmpty
                ? Center(child: Text(S.of(context).NoActiveO))
                : Expanded(
                    child: ListView.builder(
                      itemCount: acOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        final order = acOrders[index];
                        return Card(
                          semanticContainer: true,
                          margin: const EdgeInsets.all(15),
                          elevation: 5,
                          borderOnForeground: true,
                          child: ListTile(
                            title: Text(order.status),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...order.items.map((item) {
                                  return Text(
                                    '- ${item.productId}: ${item.quantity} x \$${item.unitPrice.toStringAsFixed(2)}',
                                  );
                                }).toList(),
                              ],
                            ),
                            trailing: Text(
                                '\$${order.totalPrice.toStringAsFixed(2)}'),
                          ),
                        );
                      },
                    ),
                  ),
            const Divider(
              thickness: 2,
              height: 3,
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                S.of(context).PastOrder,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            pastOrders.isEmpty
                ? Center(child: Text(S.of(context).NoPastOrd))
                : Expanded(
                    child: ListView.builder(
                      itemCount: pastOrders.length,
                      itemBuilder: (BuildContext context, int index) {
                        final order = pastOrders[index];
                        return Card(
                          margin: const EdgeInsets.all(15),
                          elevation: 5,
                          child: ListTile(
                            title: Text('Order ID: ${order.orderId}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: ${order.status}'),
                                Text(
                                    'Total Price: \$${order.totalPrice.toStringAsFixed(2)}'),
                                Text('Created At: ${order.createdAt}'),
                                const SizedBox(height: 10),
                                const Text('Items:'),
                                ...order.items.map((item) {
                                  return Text(
                                    '- ${item.productId}: ${item.quantity} x \$${item.unitPrice.toStringAsFixed(2)}',
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
