class SignUpBody {
  final String email;
  final String username;
  final String password;

  SignUpBody(
      {required this.email, required this.username, required this.password});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['username'] = username;
    data['password'] = password;

    return data;
  }
}
