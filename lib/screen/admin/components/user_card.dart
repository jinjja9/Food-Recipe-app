import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onTap;
  final VoidCallback? onMorePressed;

  const UserCard(
      {super.key, required this.user, this.onTap, this.onMorePressed});

  String formatDate(dynamic createdAt) {
    if (createdAt == null) return 'N/A';
    DateTime date;
    if (createdAt is Timestamp) {
      date = createdAt.toDate();
    } else if (createdAt is DateTime) {
      date = createdAt;
    } else if (createdAt is String) {
      try {
        date = DateTime.parse(createdAt);
      } catch (_) {
        return createdAt.toString();
      }
    } else {
      return createdAt.toString();
    }
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Future<int> getFoodCount(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('foods')
        .where('uid', isEqualTo: userId)
        .get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: user['avatarImage'] != null &&
                        user['avatarImage'].isNotEmpty
                    ? NetworkImage(user['avatarImage'])
                    : const AssetImage('assets/images/avatar1.png')
                        as ImageProvider,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user['role'] != null) ...[
                      _buildRoleBadge(user['role']),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      user['name'] ?? user['username'] ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (user['email'] != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        user['email'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    if (user['createdAt'] != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Ngày tạo: ${formatDate(user['createdAt'])}',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                    // Dòng số lượng món ăn dùng FutureBuilder
                    FutureBuilder<int>(
                      future: getFoodCount(user['uid']),
                      builder: (context, snapshot) {
                        final foodCount = snapshot.data ?? 0;
                        return Row(
                          children: [
                            Text(
                              'Số món ăn: $foodCount',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              if (onMorePressed != null)
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: onMorePressed,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color = role == "admin" ? Colors.red : Colors.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        role == "admin" ? "Admin" : "Người dùng",
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
