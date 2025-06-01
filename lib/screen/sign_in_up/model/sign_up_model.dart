class SignUpModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool agreeToTerms;

  SignUpModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.agreeToTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'agreeToTerms': agreeToTerms,
    };
  }
}
