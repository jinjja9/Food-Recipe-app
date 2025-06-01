import 'package:flutter/material.dart';

import '../model/sign_up_model.dart';

class SignUpViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _obscureText1 = true;
  bool _obscureText2 = true;
  bool _agreeToTerms = false;

  bool get obscureText1 => _obscureText1;
  bool get obscureText2 => _obscureText2;
  bool get agreeToTerms => _agreeToTerms;

  void togglePasswordVisibility1() {
    _obscureText1 = !_obscureText1;
    notifyListeners();
  }

  void togglePasswordVisibility2() {
    _obscureText2 = !_obscureText2;
    notifyListeners();
  }

  void toggleTermsAgreement(bool? value) {
    _agreeToTerms = value ?? false;
    notifyListeners();
  }

  SignUpModel getSignUpData() {
    return SignUpModel(
      name: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      agreeToTerms: _agreeToTerms,
    );
  }

  bool validateForm() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      return false;
    }

    if (!_agreeToTerms) {
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
