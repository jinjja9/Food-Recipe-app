import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LikedUsersDialog extends StatelessWidget {
  final List<String> likedUserIds;

  const LikedUsersDialog({
    Key? key,
    required this.likedUserIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Người dùng đã thích',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (likedUserIds.isEmpty)
              const Text('Chưa có người dùng nào thích món ăn này')
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: likedUserIds.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(likedUserIds[index])
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const ListTile(
                            leading: CircularProgressIndicator(),
                            title: Text('Đang tải...'),
                          );
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Người dùng không tồn tại'),
                          );
                        }

                        final userData = snapshot.data!.data() as Map<String, dynamic>;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: userData['avatarImage'] != null
                                ? NetworkImage(userData['avatarImage'])
                                : null,
                            child: userData['avatarImage'] == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          title: Text(userData['username'] ?? 'Không có tên'),
                          subtitle: Text(userData['email'] ?? ''),
                        );
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      ),
    );
  }
} 