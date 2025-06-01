abstract class SignUpState {}
class SignUpInitial extends SignUpState {}
class SignUpLoading extends SignUpState {}
class SignUpSuccess extends SignUpState {
  final String userId;
  final String message;
  SignUpSuccess(this.userId, this.message);
}

class SignUpFailure extends SignUpState {
  final String error;
  SignUpFailure(this.error);
} 