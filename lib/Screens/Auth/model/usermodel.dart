class UserModel {
  String name;
  String email;

  int age;

  String id;

  UserModel(
      {required this.name,
      required this.email,
      required this.age,
      this.id = ""});

  UserModel.fromJason(Map<String, dynamic> jason)
      : this(
          name: jason["name"],
          email: jason["email"],
          id: jason["id"],
          age: jason["age"],
        );

  Map<String, dynamic> toJason() {
    return {
      "name": name,
      "email": email,
      "id": id,
      "age": age,
    };
  }
}
