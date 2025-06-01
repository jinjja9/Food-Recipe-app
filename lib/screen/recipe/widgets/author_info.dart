import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthorInfo extends StatefulWidget {
  final String authorId;

  const AuthorInfo({
    super.key,
    required this.authorId,
  });

  @override
  State<AuthorInfo> createState() => _AuthorInfoState();
}

class _AuthorInfoState extends State<AuthorInfo> {
  Map<String, dynamic>? _cachedUserData;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkFollowStatus();
  }

  Future<void> _loadUserData() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.authorId)
          .get();
      
      if (docSnapshot.exists) {
        setState(() {
          _cachedUserData = docSnapshot.data();
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _checkFollowStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.authorId)
          .get();
      
      if (docSnapshot.exists) {
        final followers = List<String>.from(docSnapshot.data()?['followers'] ?? []);
        setState(() {
          _isFollowing = followers.contains(currentUser.uid);
        });
      }
    } catch (e) {
      print('Error checking follow status: $e');
    }
  }

  Future<void> _toggleFollow() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.authorId);
      
      if (_isFollowing) {
        await userRef.update({
          'followers': FieldValue.arrayRemove([currentUser.uid])
        });
      } else {
        await userRef.update({
          'followers': FieldValue.arrayUnion([currentUser.uid])
        });
      }

      setState(() {
        _isFollowing = !_isFollowing;
      });
    } catch (e) {
      print('Error toggling follow status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final isCurrentUser = currentUser?.uid == widget.authorId;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _cachedUserData == null
          ? const Row(
              children: [
                CircleAvatar(radius: 60, child: CircularProgressIndicator()),
                SizedBox(width: 16),
                Text('Đang tải...', style: TextStyle(fontSize: 16)),
              ],
            )
          : Row(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 58,
                    backgroundImage: _cachedUserData!['avatarImage']?.isNotEmpty == true
                        ? NetworkImage(_cachedUserData!['avatarImage'])
                        : null,
                    child: _cachedUserData!['avatarImage']?.isEmpty ?? true
                        ? const Icon(Icons.person)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đóng góp bởi',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        _cachedUserData!['name'] ?? 'Người dùng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[400],
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                if (!isCurrentUser)
                  ElevatedButton(
                    onPressed: _toggleFollow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFollowing ? Colors.grey.shade200 : Colors.orange.shade50,
                      foregroundColor: _isFollowing ? Colors.grey : Colors.orange,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(_isFollowing ? 'Đã theo dõi' : 'Theo dõi'),
                  ),
              ],
            ),
    );
  }
} 