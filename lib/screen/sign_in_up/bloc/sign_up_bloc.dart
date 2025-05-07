import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpSubmitted>(_onSignUpSubmitted);
    on<SignUpReset>(_onSignUpReset);
    on<SignUpToggleAgree>(_onSignUpToggleAgree);
  }

  Future<void> _onSignUpSubmitted(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    emit(SignUpLoading());

    if (event.password != event.confirmPassword) {
      emit(SignUpFailure('Mật khẩu xác nhận không khớp'));
      return;
    }

    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      await userCredential.user?.updateDisplayName(event.username);

      emit(SignUpSuccess('Đăng ký thành công!'));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email này đã được sử dụng';
          break;
        case 'invalid-email':
          errorMessage = 'Email không hợp lệ';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Đăng ký bằng email/password không được bật';
          break;
        case 'weak-password':
          errorMessage = 'Mật khẩu quá yếu';
          break;
        default:
          errorMessage = 'Hãy điền đầy đủ thông tin';
      }
      emit(SignUpFailure(errorMessage));
    } catch (e) {
      emit(SignUpFailure('Đăng kí thành công'));
    }
  }

  void _onSignUpReset(
    SignUpReset event,
    Emitter<SignUpState> emit,
  ) {
    emit(SignUpInitial());
  }

  void _onSignUpToggleAgree(
    SignUpToggleAgree event,
    Emitter<SignUpState> emit,
  ) {
    // Không cần xử lý gì nữa vì đã bỏ checkbox
  }
}
