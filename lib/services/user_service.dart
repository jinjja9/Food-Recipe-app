import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static Future<void> createUser({
    required String uid,
    required String email,
    required String username,
    String role = 'user',
  }) async {
    await FirebaseFirestore.instance.collection('user').doc(uid).set({
      'email': email,
      'username': username,
      'role': role,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
} 