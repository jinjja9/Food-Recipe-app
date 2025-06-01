abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool agreeToTerms;

  SignUpSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.agreeToTerms,
  });
}

class SignUpReset extends SignUpEvent {}

class SignUpToggleAgree extends SignUpEvent {
  final bool value;
  SignUpToggleAgree(this.value);
} 