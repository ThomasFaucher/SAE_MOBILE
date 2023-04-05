class User {
  int id;
  final String name;
  final String email;
  final String password;
  static int nb = 1;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  int get idUser => id;
  String get nameUser => name;
  String get emailUser => email;
  String get passwordUser => password;

  set setId(int value) {
    this.id = value;
  }
  factory User.newUser(name, email, password) {
    //print to see the value of nb
    nb++;
    return User(
        id: nb,
        name: name,
        email: email,
        password: password
    );
  }
  factory User.fromJson(Map<String, dynamic> json) {
    nb = json['id'];
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, password: $password}';
  }
}
