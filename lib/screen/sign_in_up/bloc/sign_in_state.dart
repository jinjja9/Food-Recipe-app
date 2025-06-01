abstract class SignInState {}

class SignInInitial extends SignInState {}
class SignInLoading extends SignInState {}
class SignInSuccess extends SignInState {
  final String userId;
  SignInSuccess(this.userId);
}
class SignInFailure extends SignInState {
  final String error;
  SignInFailure(this.error);
} 