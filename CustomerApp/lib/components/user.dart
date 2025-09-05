class User {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String city;
  final String gender;
  final String birthDate;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.city,
    required this.gender,
    required this.birthDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      gender: json['gender'],
      birthDate: json['birthDate'],
    );
  }
}
