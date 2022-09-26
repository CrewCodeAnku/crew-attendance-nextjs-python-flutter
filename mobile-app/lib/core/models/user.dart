class User {
  String? userId;
  String? name;
  String? email;
  String? type;
  String? token;
  String? renewalToken;
  String? issplash;
  String? profilePic;

  User(
      {this.userId,
      this.name,
      this.email,
      this.type,
      this.token,
      this.renewalToken,
      this.issplash,
      this.profilePic});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        userId: responseData['id'],
        name: responseData['name'],
        email: responseData['email'],
        type: responseData['type'],
        token: responseData['access_token'],
        renewalToken: responseData['refresh_token'],
        profilePic: responseData['profile_picture']);
  }
}
