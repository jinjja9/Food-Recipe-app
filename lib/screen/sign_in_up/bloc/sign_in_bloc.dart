import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SignInBloc() : super(SignInInitial()) {
    on<SignInSubmitted>(_onSignInSubmitted);
  }

  Future<void> _onSignInSubmitted(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    emit(SignInLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      final userId = userCredential.user?.uid ?? '';
      emit(SignInSuccess(userId));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Tài khoản không tồn tại';
          break;
        case 'wrong-password':
          errorMessage = 'Mật khẩu không đúng';
          break;
        case 'invalid-email':
          errorMessage = 'Email không hợp lệ';
          break;
        default:
          errorMessage = 'Hãy điền đầy đủ thông tin';
      }
      emit(SignInFailure(errorMessage));
    } catch (e) {
      emit(SignInFailure('Đăng nhập thành công!'));
    }
  }
}
