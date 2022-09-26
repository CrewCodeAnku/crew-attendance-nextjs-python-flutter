class Student {
  final String? id;
  final String? name;
  // ignore: non_constant_identifier_names
  final String? profile_picture;
  final String? email;

  Student({
    this.id,
    this.name,
    // ignore: non_constant_identifier_names
    this.profile_picture,
    this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['id'] ?? "",
        name: json['name'] ?? "",
        profile_picture: json['profile_picture'] ?? "https://img.icons8.com/external-sbts2018-flat-sbts2018/58/000000/external-user-ecommerce-basic-1-sbts2018-flat-sbts2018.png",
        email: json['email'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_picture': profile_picture,
      'email': email
    };
  }
}
