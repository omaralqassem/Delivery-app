import 'dart:convert';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';
import 'package:http/http.dart' as http;

final _controller = PageController();

final TextEditingController fname = TextEditingController();
final TextEditingController lname = TextEditingController();
final TextEditingController birth = TextEditingController();
final TextEditingController address = TextEditingController();
final TextEditingController email = TextEditingController();
final TextEditingController mobileNumber = TextEditingController();
final TextEditingController password = TextEditingController();
final TextEditingController confirmPassword = TextEditingController();
final TextEditingController selectedCity = TextEditingController();
final TextEditingController selectedGender = TextEditingController();

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              S.of(context).CreateAcc,
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
            Expanded(
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Page1(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Page2(),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(S.of(context).AlreHav),
                TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(context, '/login');
                    },
                    child: Text(
                      S.of(context).LogIn,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension NameValidator on String {
  bool isValidName() {
    return RegExp(r'^[A-Z]{1}.([^0-9]*)$').hasMatch(this);
  }
}

extension BDValidator on String {
  bool isValidBD() {
    return RegExp(r'(^(20|19)[0-9]{2}/[0-9]{2}/[0-9]{2}$)').hasMatch(this);
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}

extension PhoneValidator on String {
  bool isValidPhone() {
    return RegExp(r'(^9[0-9]{8}$)').hasMatch(this);
  }
}

var _pass;

extension PasswordValidator on String {
  bool isValidPassword() {
    _pass = this;
    return RegExp(
            r'^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9].*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$')
        .hasMatch(this);
  }
}

extension ConfirmPasswordValidator on String {
  bool isPasswordConfirmed() {
    return this == _pass;
  }
}

//====================================Page2=====================================//
class Page2 extends StatefulWidget {
  const Page2({
    super.key,
  });

  @override
  State<Page2> createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  Future<http.Response> register() async {
    final apiUrl = 'http://10.0.2.2:8000/api/auth/register';
    print('Signup button clicked');
    if (!email.text.isValidEmail() ||
        !mobileNumber.text.isValidPhone() ||
        !password.text.isValidPassword() ||
        !confirmPassword.text.isPasswordConfirmed()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(S.of(context).fillAll)));
    }
    final Map<String, dynamic> data = {
      'firstname': fname.text,
      'lastname': lname.text,
      'date_of_birth': birth.text,
      'address': address.text,
      'role': 'customer',
      'email': email.text,
      'phone_number': mobileNumber.text,
      'password': password.text,
      'password_confirmation': confirmPassword.text,
      'gender': selectedGender.text,
      'city': selectedCity.text
    };
    final String body = json.encode(data);
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: body,
        headers: {'Content-Type': 'application/json'},
      );

      print(birth);
      print(address);
      print(email);
      print(mobileNumber);
      print(password);
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Registration successful');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.body)));
      }

      return response; // Return the response object
    } catch (e) {
      print('Error: $e');
      throw e; // Rethrow the exception
    }
  }

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        TextFormField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: (input) =>
              input!.isValidEmail() ? null : S.of(context).NotVEmail,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.of(context).SetEmail,
            labelStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            hintText: S.of(context).SetEmail,
            hintStyle: const TextStyle(height: 1),
            prefixIcon: Icon(Icons.email_outlined),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13))),
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: mobileNumber,
          keyboardType: TextInputType.phone,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: (input) => input!.isValidPhone() ? null : "9XXXXXXXX",
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.of(context).SetNumber,
            labelStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            hintText: S.of(context).SetNumber,
            prefixText: '+963 ',
            hintStyle: const TextStyle(height: 1),
            prefixIcon: Icon(Icons.numbers),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13))),
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: password,
          obscureText: !_passwordVisible,
          enableSuggestions: false,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: (input) =>
              input!.isValidPassword() ? null : S.of(context).NotVPass,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.of(context).SetPassword,
            labelStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
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
        SizedBox(height: 20),
        TextFormField(
          controller: confirmPassword,
          obscureText: !_passwordVisible,
          enableSuggestions: false,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: (input) =>
              input!.isPasswordConfirmed() ? null : S.of(context).NotMatch,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.of(context).SetConfirmPassword,
            labelStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            hintText: S.of(context).SetConfirmPassword,
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
        const SizedBox(height: 20),
        Container(
          height: 60,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0)))),
            // onPressed: () => Navigator.popAndPushNamed(context, '/login'),
            onPressed: () => register(),
            child: Text(
              S.of(context).CreateAcc,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//========================================================Page1=================================================
class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> sex = [
      S.of(context).SetGenderM,
      S.of(context).SetGenderF,
    ];
    final List<String> cities = [
      S.of(context).SetCityA,
      S.of(context).SetCityD,
      S.of(context).SetCityH,
      S.of(context).SetCityL
    ];
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextFormField(
                controller: fname,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (input) =>
                    input!.isValidName() ? null : S.of(context).NotVName,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetFirstName,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetFirstName,
                  hintStyle: const TextStyle(height: 1),
                  prefixIcon: Icon(Icons.person_2_outlined),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Flexible(
              flex: 1,
              child: TextFormField(
                controller: lname,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (input) =>
                    input!.isValidName() ? null : S.of(context).NotVName,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetLastName,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetLastName,
                  hintStyle: const TextStyle(height: 1),
                  prefixIcon: Icon(Icons.person_2_outlined),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: TextFormField(
                controller: birth,
                autovalidateMode: AutovalidateMode.onUnfocus,
                validator: (input) =>
                    input!.isValidBD() ? null : S.of(context).NotVBD,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: S.of(context).SetBD,
                  labelStyle:
                      TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  hintText: S.of(context).SetBD,
                  hintStyle: const TextStyle(height: 1),
                  prefixIcon: Icon(Icons.date_range_outlined),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              flex: 1,
              child: DropdownButtonFormField<String>(
                hint: Text(
                  S.of(context).SetGender,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(13))),
                  labelText: S.of(context).SetGender,
                  hintStyle: const TextStyle(
                    height: 1,
                  ),
                  labelStyle:
                      TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
                  prefixIcon: Icon(Icons.male_outlined),
                ),
                items: sex.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (newValue) {
                  selectedGender.text = newValue!.toLowerCase();
                },
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: address,
          autovalidateMode: AutovalidateMode.onUnfocus,
          validator: (input) =>
              input!.isEmpty ? S.of(context).NotVAddress : null,
          keyboardType: TextInputType.streetAddress,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: S.of(context).SetAdress,
            labelStyle: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            hintText: S.of(context).SetAdress,
            prefixIcon: Icon(Icons.location_on_outlined),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13))),
          ),
        ),
        SizedBox(height: 20),
        DropdownButtonFormField<String>(
          hint: Text(
            S.of(context).SetCity,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(13))),
            labelText: S.of(context).SetCity,
            labelStyle: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
            prefixIcon: Icon(Icons.location_city_outlined),
          ),
          items: cities.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (newValue) {
            selectedCity.text = newValue!;
          },
        ),
        const SizedBox(height: 20),
        Container(
          height: 60,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: ElevatedButton(
            style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.0)))),
            onPressed: () {
              if (!fname.text.isValidName() ||
                  !lname.text.isValidName() ||
                  !birth.text.isValidBD() ||
                  address.text.isEmpty ||
                  selectedCity.text.isEmpty ||
                  selectedGender.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(S.of(context).fillAll)));
              } else {
                _controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              }
            },
            child: Text(
              S.of(context).Next,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
