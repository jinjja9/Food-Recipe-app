class SignUpModel {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final bool agreeToTerms;

  SignUpModel({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.agreeToTerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'agreeToTerms': agreeToTerms,
    };
  }
} 