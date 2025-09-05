import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import '../generated/l10n.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Uint8List? _imageBytes; // To store the profile image bytes
  bool _isLoading = true; // To show a loading state

  @override
  void initState() {
    super.initState();
    _fetchProfileImage(); // Fetch the profile image when the drawer is initialized
  }

  Future<void> _fetchProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('authToken');

    if (authToken == null) {
      print('No token found. Please log in again.');
      return;
    }

    final String apiUrl =
        'http://10.0.2.2:8000/api/auth/profile'; // Replace with your API endpoint

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userInfo = json.decode(response.body);

        // Fetch the image URL from the server
        if (userInfo['profile_photo'] != null) {
          final imageUrl =
              'http://10.0.2.2:8000/storage/${userInfo['profile_photo']}';
          await _loadImageFromUrl(imageUrl);
        }
      } else {
        print('Failed to fetch user information.');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  Future<void> _loadImageFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = response.bodyBytes; // Store the image as bytes
        });
      }
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // CircleAvatar with the profile photo
            _isLoading
                ? const CircularProgressIndicator() // Show a loader while fetching
                : CircleAvatar(
                    radius: 75,
                    backgroundImage: _imageBytes != null
                        ? MemoryImage(
                            _imageBytes!) // Display the image if available
                        : null,
                    child: _imageBytes == null
                        ? const Text(
                            'AB') // Fallback text if no image is available
                        : null,
                  ),
            const Divider(
              indent: 20,
              endIndent: 20,
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: ListTile(
                title: Text(S.of(context).DrawerProflie),
                leading: const Icon(Icons.person_2_outlined),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/accs');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25),
              child: ListTile(
                title: Text(S.of(context).DrawerCart),
                leading: const Icon(Icons.shopping_cart_outlined),
                onTap: () => Navigator.pushNamed(context, '/cart'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25),
              child: ListTile(
                title: Text(S.of(context).DrawerFav),
                leading: const Icon(Icons.star_border_outlined),
                onTap: () => Navigator.pushNamed(context, '/favorites'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25),
              child: ListTile(
                title: Text(S.of(context).DrawerHistory),
                leading: const Icon(Icons.history_outlined),
                onTap: () => Navigator.pushNamed(context, '/orderhist'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25),
              child: ListTile(
                title: Text(S.of(context).DrawerSet),
                leading: const Icon(Icons.settings_outlined),
                onTap: () => Navigator.pushNamed(context, "/set"),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 25),
              child: ListTile(
                title: Text(S.of(context).logout),
                leading: const Icon(Icons.logout),
                onTap: () => Navigator.pushNamed(context, "/login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
