import 'package:flutter/material.dart';
import '../generated/l10n.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Image.asset(
            'assets/photos/flutter_logo.png',
            height: 350,
          ),
          Text(
            S.of(context).Welcome,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/signup');
              },
              child: Text(S.of(context).CreateAcc),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/login');
              },
              child: Text(S.of(context).Login),
            ),
          ),
        ],
      ),
    );
  }
}
