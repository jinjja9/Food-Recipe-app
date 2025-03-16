import 'package:flutter/material.dart';

import '../../core/color.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.12),
                  // Tiêu đề
                  const Text(
                    'Chúng tôi sẽ giúp\nbạn lấy lại mật khẩu',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: backgroundButton),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  // Ô nhập "Mật khẩu mới"
                  const TextField(
                    decoration: InputDecoration(
                        labelText: 'Mật khẩu mới',
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  // Ô nhập "Xác nhận mật khẩu"
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Xác nhận mật khẩu',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  // Nút "Xác nhận"
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundButton,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      minimumSize: Size(double.infinity, screenHeight * 0.06),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Xác nhận',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * 0.02,
              left: screenWidth * 0.02,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
