import 'package:flutter/material.dart';
import '../../components/notification_service.dart';
import 'MyTimeline.dart';
import '../../generated/l10n.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projectst/Pages/OrderHistory/ParsingOrders.dart';

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  Orders? _currentOrder;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPendingOrders();
  }

  Future<void> _fetchPendingOrders() async {
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

      final pendingOrder = ordersList.firstWhere(
        (order) => order.status == "pending" || order.status == "shipped",
      );

      setState(() {
        _currentOrder = pendingOrder;
        _isLoading = false;
      });
    } else {
      print('Failed to load orders');
    }
  }

  Future<void> _updateOrderStatus() async {
    if (_currentOrder == null) return;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('authToken');

    if (authToken == null) {
      print('Token not found');
      return;
    }

    String newStatus;
    if (_currentOrder!.status == "pending") {
      newStatus = "shipped";
      NotificationService().showNotification(
          title: 'Wasselha', body: 'Your order is on the way!');
    } else if (_currentOrder!.status == "shipped") {
      newStatus = "completed";
      NotificationService().showNotification(
          title: 'Wasselha', body: 'Your order is Delivered!');
    } else {
      return;
    }
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/orders/${_currentOrder!.orderId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({'status': newStatus}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _currentOrder!.status = newStatus; // Update the local order status
        });
      } else {
        print(response.statusCode);
        print('Failed to update order status ');
      }
    } catch (e) {
      print(e);
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
        title: Text(S.of(context).TrackingTitle),
      ),
      body: _isLoading
          ? const Center(child: Text("There is no active orders"))
          : RefreshIndicator(
              onRefresh: _updateOrderStatus, // Refresh to update order status
              child: ListView(
                children: [
                  Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 1)],
                      color: Color.fromARGB(207, 227, 255, 151),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: const Image(
                        image: AssetImage('assets/photos/tracking.png')),
                  ),
                  MyTimeline(
                    isDone: _currentOrder!.status == "pending" ||
                        _currentOrder!.status == "shipped" ||
                        _currentOrder!.status == "completed",
                    st: S.of(context).TrackingPlaced,
                    isFirst: true,
                    isLast: false,
                  ),
                  MyTimeline(
                    isDone: _currentOrder!.status == "shipped" ||
                        _currentOrder!.status == "completed",
                    st: S.of(context).TrackingITW,
                    isFirst: false,
                    isLast: false,
                  ),
                  MyTimeline(
                    isDone: _currentOrder!.status == "completed",
                    st: S.of(context).TrackingDone,
                    isFirst: false,
                    isLast: true,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).TrackingDetails),
                        if (_currentOrder != null) ...[
                          Text('Order ID: ${_currentOrder!.orderId}'),
                          Text('Status: ${_currentOrder!.status}'),
                          Text(
                              'Total Price: \$${_currentOrder!.totalPrice.toStringAsFixed(2)}'),
                          const SizedBox(height: 10),
                          const Text('Items:'),
                          ..._currentOrder!.items.map((item) {
                            return Text(
                              '- ${item.productId}: ${item.quantity} x \$${item.unitPrice.toStringAsFixed(2)}',
                            );
                          }).toList(),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 140),
                ],
              ),
            ),
    );
  }
}
