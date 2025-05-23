import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createUser({
    required String uid,
    required String email,
    required String name,
    required String password,
    String role = 'user',
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'name': name,
      'password': password,
      'role': role,
      'avatarImage': 'https://cdn-icons-png.flaticon.com/512/149/149071.png',
      'createdAt': FieldValue.serverTimestamp(),
      'followers': [],
    });
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return doc.data();
  }

  static Stream<User?> getAuthStateChanges() {
    return _auth.authStateChanges();
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
  
} 