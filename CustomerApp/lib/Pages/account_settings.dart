import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

extension NameValidator on String {
  bool isValidName() {
    return RegExp(r'^[A-Z]{1}.([^0-9]*)$').hasMatch(this);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

final TextEditingController _firstNameController = TextEditingController();
final TextEditingController _lastNameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _addressController = TextEditingController();

String? gender;
String? birthDate;
String? selectedCity;

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

  @override
  State<AccountSettings> createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  List<String> cities = [];
  Uint8List? _imageBytes;

  @override
  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('authToken');

    if (authToken == null) {
      print('No token found. Please log in again.');
      return;
    }

    final String apiUrl = 'http://10.0.2.2:8000/api/auth/profile';
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
        setState(() {
          userData = userInfo;
          isLoading = false;

          _firstNameController.text = userInfo['firstname'] ?? '';
          _lastNameController.text = userInfo['lastname'] ?? '';
          _emailController.text = userInfo['email'] ?? '';
          _addressController.text = userInfo['address'] ?? '';

          selectedCity = userInfo['city'] ?? S.of(context).SetCityA;
          gender = userInfo['gender'] ?? S.of(context).SetGenderM;
          birthDate = userInfo['date_of_birth'] ?? '12/12/2024';

          // Fetch the image URL from the server
          if (userInfo['profile_photo'] != null) {
            _loadImageFromUrl(
                'http://10.0.2.2:8000/storage/${userInfo['profile_photo']}');
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user information.')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadImageFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          _imageBytes = response.bodyBytes;
        });
      }
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  Future<void> _updateUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('authToken');

    if (authToken == null) {
      print('No token found. Please log in again.');
      return;
    }

    final String apiUrl = 'http://10.0.2.2:8000/api/auth/updateProfile';

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..headers['Authorization'] = 'Bearer $authToken';

      request.fields['firstname'] = _firstNameController.text;
      request.fields['lastname'] = _lastNameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['address'] = _addressController.text;
      request.fields['city'] = selectedCity ?? '';

      // Add the image file if selected
      if (_imageBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image', // Field name for the image on the server
            _imageBytes!,
            filename: 'profile_image.jpg', // Optional: Provide a filename
          ),
        );
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User information updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user information.')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  void showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Choose a new photo'),
              onTap: () {
                Navigator.pop(context);
                pickImage();
              },
            ),
            if (_imageBytes != null)
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete photo'),
                onTap: () {
                  Navigator.pop(context);
                  deleteImage();
                },
              ),
          ],
        );
      },
    );
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final bytes = await file.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void deleteImage() {
    setState(() {
      _imageBytes = null;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateCities();
  }

  void _updateCities() {
    setState(() {
      cities = {
        S.of(context).SetCityA,
        S.of(context).SetCityD,
        S.of(context).SetCityH,
        S.of(context).SetCityL
      }.toList();
      // print('Cities: $cities');
      // print('Selected City: $selectedCity');

      if (!cities.contains(selectedCity)) {
        selectedCity = cities.isNotEmpty ? cities[0] : null;
      }
    });
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
        title: Text(S.of(context).SetTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        children: [
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  backgroundImage:
                      _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                        onPressed: () {
                          showImageOptions(context);
                        },
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 15,
                        )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              SizedBox(height: 10.0),
              TextFormField(
                controller: _firstNameController,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUnfocus,
                onChanged: (value) {
                  print('First Name Updated: $value');
                },
                validator: (input) =>
                    input!.isValidName() ? null : S.of(context).NotVName,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetFirstName,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetFirstName,
                  prefixIcon: Icon(Icons.person_2_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _lastNameController,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUnfocus,
                onChanged: (value) {
                  print(' $value');
                },
                validator: (input) =>
                    input!.isValidName() ? null : S.of(context).NotVName,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetLastName,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetLastName,
                  prefixIcon: Icon(Icons.person_2_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUnfocus,
                onChanged: (value) {
                  print(' $value');
                },
                validator: (input) =>
                    input!.isValidEmail() ? null : S.of(context).NotVEmail,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetEmail,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetEmail,
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                keyboardType: TextInputType.streetAddress,
                autovalidateMode: AutovalidateMode.onUnfocus,
                onChanged: (value) {
                  print(' $value');
                },
                validator: (input) =>
                    input!.isEmpty ? S.of(context).NotVAddress : null,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetAdress,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetAdress,
                  prefixIcon: Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: OutlineInputBorder(),
                  labelText: S.of(context).SetCity,
                  labelStyle:
                      TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
                value: selectedCity,
                items: cities.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${S.of(context).SetGender}: ${gender ?? ''}",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text("${S.of(context).SetBD}: ${birthDate ?? ''}",
                      style: TextStyle(fontSize: 17)),
                ],
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              boxShadow: const [BoxShadow(spreadRadius: 1, blurRadius: 1)],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (!_firstNameController.text.isValidName() ||
                      !_lastNameController.text.isValidName() ||
                      !_emailController.text.isValidEmail() ||
                      _addressController.text.isEmpty ||
                      selectedCity!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.of(context).fillAll)),
                    );
                  } else {
                    _updateUserInfo();
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
                child: Text(
                  S.of(context).SetSave,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
