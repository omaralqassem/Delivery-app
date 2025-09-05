import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _passwordVisible = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final String? authToken = prefs.getString('authToken');

    if (authToken == null) {
      print('No token found. Please log in again.');
      return;
    }

    final String apiUrl =
        'http://10.0.2.2:8000/api/auth/updatePassword'; // Replace with your actual API endpoint
    final Map<String, dynamic> updatedData = {
      'old_password': _currentPasswordController.text,
      'password': _newPasswordController.text,
      'password_confirmation': _confirmPasswordController.text
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode(updatedData),
      );
      print(updatedData);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).changeTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                enableSuggestions: false,
                autocorrect: false,
                controller: _currentPasswordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetPassword,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetOldPassword,
                  hintStyle: const TextStyle(height: 1),
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).PleaseE;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetPassword,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetNewPassword,
                  hintStyle: const TextStyle(height: 1),
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).PleaseEtn;
                  }
                  if (value.length < 6) {
                    return S.of(context).Password6LETTER;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetPassword,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetConfirmPassword,
                  hintStyle: const TextStyle(height: 1),
                  prefixIcon: Icon(Icons.password),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).Pleaseconfirmyournewpassword;
                  }
                  if (value != _newPasswordController.text) {
                    return S.of(context).Passwordsdonotmatch;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updatePassword,
                child: Text(S.of(context).ChangePassword),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
