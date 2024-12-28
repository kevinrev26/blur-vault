class Account {
  int? id;
  String name;
  String password;
  String dateAdded;

  Account(
      {this.id,
      required this.name,
      required this.password,
      required this.dateAdded});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'dateAdded': dateAdded,
    };
  }

  static Account fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      name: map['name'],
      password: map['password'],
      dateAdded: map['dateAdded'],
    );
  }
}
