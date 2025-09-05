import 'package:flutter/material.dart';
import '../components/checkout_service.dart';
import '../generated/l10n.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _CheckoutScreenState();
}

final TextEditingController selectedPayment = TextEditingController();

class _CheckoutScreenState extends State<PaymentPage> {
  bool _isAsapDeliverySelected = true;

  final List<String> _paymentMethods = [
    "Cash",
    "Visa",
    "Card",
    "Syriatel Cash",
  ];

  void _onScheduledDateChange(String date) {
    setState(() {});
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
        title: Text(S.of(context).Checkout),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).DeliveryTime,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: _isAsapDeliverySelected,
                    onChanged: (value) {
                      setState(() {
                        _isAsapDeliverySelected = true;
                      });
                    },
                  ),
                  Text(S.of(context).ASAP),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: false,
                    groupValue: _isAsapDeliverySelected,
                    onChanged: (value) {
                      setState(() {
                        _isAsapDeliverySelected = false;
                      });
                    },
                  ),
                  Text(S.of(context).Schd),
                ],
              ),
              if (!_isAsapDeliverySelected)
                TextField(
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    hintText: 'YYYY/MM/DD',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _onScheduledDateChange,
                ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                hint: Text(
                  S.of(context).PayWith,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                  labelText: S.of(context).PayWith,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                items: _paymentMethods.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedPayment.text = newValue!;
                },
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).DeliveryFee,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                '10\$',
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).fp,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text((CheckoutService.total + 10).toString() + '\$'),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 60,
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                if (selectedPayment.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).fillAll)),
                  );
                } else {
                  await CheckoutService.checkout(
                      payment_method: selectedPayment.text);
                  selectedPayment.clear();
                  CheckoutService.ckeckedOut
                      ? showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(S.of(context).PAS),
                            content: Text(S.of(context).Oplaced),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).popUntil(
                                    ModalRoute.withName('/home_page')),
                                child: Text(S.of(context).OK),
                              ),
                            ],
                          ),
                        )
                      : ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Something went wring :(')),
                        );
                }
              },
              child: Text(
                S.of(context).PlaceOrder,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
