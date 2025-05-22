import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/color.dart';
import '../../home/main_screen.dart';
import '../bloc/sign_up_bloc.dart';
import '../bloc/sign_up_event.dart';
import '../bloc/sign_up_state.dart';
import '../sign_in_screen.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpBloc(),
      child: const _SignUpViewContent(),
    );
  }
}

class _SignUpViewContent extends StatefulWidget {
  const _SignUpViewContent();

  @override
  State<_SignUpViewContent> createState() => _SignUpViewContentState();
}

class _SignUpViewContentState extends State<_SignUpViewContent> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();
  bool _obscureText1 = true;
  bool _obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) async {
        if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng ký thành công!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen(userId: state.userId)),
          );
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
          if (state.error == 'Đăng nhập thành công!') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MainScreen(userId: userId)),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  // Back button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios,
                        color: backgroundButton),
                  ),
                  const Text(
                    'Đăng ký\ntài khoản của bạn',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: backgroundButton,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Subtitle
                  const Text(
                    'Tạo tài khoản để khám phá công thức nấu ăn tuyệt vời',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Form fields
                  _buildTextField(
                    context,
                    controller: usernameController,
                    label: 'Tên người dùng',
                    hint: 'Nhập tên của bạn',
                    icon: Icons.person,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    context,
                    controller: emailController,
                    label: 'Email',
                    hint: 'Nhập email của bạn',
                    icon: Icons.email,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    context,
                    controller: passwordController,
                    label: 'Mật khẩu',
                    hint: 'Nhập mật khẩu của bạn',
                    icon: Icons.lock,
                    obscureText: _obscureText1,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    context,
                    controller: confirmPasswordController,
                    label: 'Xác nhận mật khẩu',
                    hint: 'Nhập lại mật khẩu của bạn',
                    icon: Icons.lock_outline,
                    obscureText: _obscureText2,
                    onToggleVisibility: () {
                      setState(() {
                        _obscureText2 = !_obscureText2;
                      });
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Register button
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              backgroundButton,
                              backgroundButton.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: backgroundButton.withOpacity(0.4),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: state is SignUpLoading
                              ? null
                              : () {
                            context.read<SignUpBloc>().add(
                              SignUpSubmitted(
                                name: usernameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                confirmPassword:
                                confirmPasswordController.text,
                                agreeToTerms: true,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: state is SignUpLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text(
                            'Đăng ký',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  // Login link
                  _buildLoginLink(context),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, {
        required TextEditingController controller,
        required String label,
        required String hint,
        required IconData icon,
        required bool obscureText,
        VoidCallback? onToggleVisibility,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: backgroundButton),
            suffixIcon: onToggleVisibility != null
                ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: backgroundButton),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Đã có tài khoản? ',
          style: TextStyle(color: Colors.black54),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: backgroundButton,
          ),
          child: const Text(
            'Đăng nhập ngay',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}