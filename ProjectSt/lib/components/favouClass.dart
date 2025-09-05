class favourites {
  final String title;
  final String size;
  final double money;
  final String picha;

  favourites({
    required this.title,
    required this.size,
    required this.money,
    required this.picha,
  });
  factory favourites.fromJson(Map<String, dynamic> json) {
    return favourites(
      title: json['title'],
      size: json['size'],
      money: json['money'],
      picha: json['picha'],
    );
  }
}
