import 'package:flutter/material.dart';
import '../../components/notification_service.dart';
import '../../generated/l10n.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

final TextEditingController emailController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
String authToken = "";

// final _controller = PageController();

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool isValidPassword() {
    return RegExp(
            r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$')
        .hasMatch(this);
  }
}

extension PhoneValidator on String {
  bool isValidPhone() {
    return RegExp(r'(^9[0-9]{8}$)').hasMatch(this);
  }
}

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  Future<void> _login() async {
    final String apiUrl = 'http://10.0.2.2:8000/api/auth/login';
    final Map<String, dynamic> data = {
      'email': emailController.text,
      'password': passwordController.text,
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      print('Request body: ${json.encode(data)}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        authToken = responseBody['token'];
        print(responseBody);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken);

        print(authToken);
        Navigator.pushReplacementNamed(context, '/home_page');
        print('Login button clicked');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Check the credentials')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loginByPhone() async {
    print(phoneController.text);
    final String apiUrl = 'http://10.0.2.2:8000/api/auth/login-by-phone';
    final Map<String, dynamic> data = {
      'phone_number': phoneController.text,
      'password': passwordController.text,
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );
      print('Request body: ${json.encode(data)}');
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        authToken = responseBody['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken);
        print(authToken);
        Navigator.pushReplacementNamed(context, '/home_page');
        print('Login button clicked');
      } else {
        print(response.body);
      }
    } catch (e) {
      print('Error: $e ');
    }
  }

  var _passwordVisible = false;
  var _loginEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),
            Text(
              S.of(context).WelcomeBack,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
            Text(
              S.of(context).Duty,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (_loginEmail)
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (input) =>
                    input!.isValidEmail() ? null : S.of(context).NotVEmail,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetEmail,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetEmail,
                  hintStyle: const TextStyle(height: 1),
                  prefixIcon: Icon(Icons.email_outlined),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                ),
              )
            else
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (input) =>
                    input!.isValidPhone() ? null : "9XXXXXXXX",
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetNumber,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetNumber,
                  prefixText: '+963 ',
                  hintStyle: const TextStyle(height: 1),
                  prefixIcon: Icon(Icons.numbers),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                ),
              ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: passwordController,
              obscureText: !_passwordVisible,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: S.of(context).SetPassword,
                labelStyle:
                    TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                hintText: S.of(context).SetPassword,
                hintStyle: const TextStyle(height: 1),
                prefixIcon: Icon(Icons.password),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
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
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      if (_loginEmail == true) {
                        _loginEmail = false;
                      } else {
                        _loginEmail = true;
                      }
                    });
                  },
                  child: _loginEmail
                      ? Text(S.of(context).LoginWphone)
                      : Text(S.of(context).LoginWemail)),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 60,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0)))),
                onPressed: () {
                  if (_loginEmail) {
                    if (!emailController.text.isValidEmail() ||
                        !passwordController.text.isValidPassword()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.of(context).fillAll)),
                      );
                    } else {
                      _login();
                    }
                  } else {
                    if (!phoneController.text.isValidPhone() ||
                        !passwordController.text.isValidPassword()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(S.of(context).fillAll)),
                      );
                    } else {
                      _loginByPhone();
                    }
                  }
                },
                child: Text(
                  S.of(context).Login,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).YdntHave),
                TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/signup');
                    },
                    child: Text(
                      S.of(context).SignUp,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
