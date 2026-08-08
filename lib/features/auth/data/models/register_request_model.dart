class RegisterRequestModel {
  final String email;
  final String password;
  final String displayName;

  const RegisterRequestModel({
    required this.email,
    required this.password,
    required this.displayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'display_name': displayName,
    };
  }
}
