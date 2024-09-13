class User {
  int? id;
  String? email;
  String? username;
  List<String>? roles;
  late bool isSignedIn;
  late bool hasShop;

  User(
      {this.id,
      this.email,
      this.username,
      this.roles,
      this.isSignedIn = false,
      this.hasShop = false});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['username'];
    roles = json['roles'].cast<String>();
    isSignedIn = false;
    hasShop = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['email'] = email;
    data['username'] = username;
    data['roles'] = roles;
    return data;
  }
}
