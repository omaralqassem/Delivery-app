import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../Pages/favorites_page.dart';
import '../Themes/le_provider.dart';
import '../Pages/DeliveryTracking/DeliveryTracking.dart';
import 'Pages/OrderHistory/orderHist.dart';
import '../Pages/SignUp&Login/loginpage.dart';
import '../Pages/SignUp&Login/signuppage.dart';
import '../Pages/cart_page.dart';
import '../Pages/home_page.dart';
import '../Pages/payment_page.dart';
import '../Pages/store_page.dart';
import '../settings.dart';
import 'start.dart';
import 'Pages/Account_Settings.dart';
import 'components/notification_service.dart';
import 'generated/l10n.dart';
import 'dart:io';

void main() {
  HttpClient.enableTimelineLogging = true; // Enable detailed logging
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LeProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Provider.of<LeProvider>(context).locale,
      localizationsDelegates: const [
        S.delegate, // A real, tangible subclass of LocalizationsDelegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: const StartPage(),
      theme: Provider.of<LeProvider>(context).themeData,
      routes: {
        '/start': (context) => const StartPage(),
        '/login': (context) => const LogInPage(),
        '/signup': (context) => SignUpPage(),
        '/home_page': (context) => const HomePage(),
        '/delivery': (context) => const Delivery(),
        '/orderhist': (context) => const OrderHist(),
        '/cart': (context) => const CartPage(),
        '/favorites': (context) => const FavoritesPage(),
        '/payment': (context) => PaymentPage(),
        '/accs': (context) => const AccountSettings(),
        '/set': (context) => SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/store_page') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return StorePage(
                storeName: args['storeName'],
                storeId: args['storeId'],
                storeImage: args['storeImage'],
              );
            },
          );
        }
      },
    );
  }
}
