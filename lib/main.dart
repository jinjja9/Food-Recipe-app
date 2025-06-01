import 'package:app/screen/home/main_screen.dart';
import 'package:app/screen/sign_in_up/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/color.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kbackgroundColor,
      ),
      //home: const WelcomeScreen(),
      home: const MainScreen(userId: 'cmMssZLRbhWVPdN8uj4f38htNkU2'),
    );
  }
}
