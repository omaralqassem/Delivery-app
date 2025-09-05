import 'package:flutter/material.dart';

import '../generated/l10n.dart';

TheShowBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (cntx) {
      return ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Product image
          Image.asset(
            'assets/photos/sneaker.png',
            height: MediaQuery.of(context).size.width / 2,
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 15.0,
          ),
          const Center(
            child: Text(
              'Yeezy 350',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Text(
              'Seller: Adidas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Text(
              'more details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            child: Text(
              'Price: 15\$',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 20,
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  label: Text(S.of(context).PDC),
                  icon: const Icon(Icons.favorite),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 20,
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  label: Text(S.of(context).PDF),
                  icon: const Icon(Icons.shopping_cart),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
