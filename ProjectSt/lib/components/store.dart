class Store {
  final String name;

  Store({required this.name});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json[
          'name'], // Adjust the key 'name' if your API returns a different one
    );
  }
}
