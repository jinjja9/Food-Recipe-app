import 'package:flutter/material.dart';
import 'user_card.dart';

class UserListView extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final Function(Map<String, dynamic>) onUserTap;
  final Function(Map<String, dynamic>)? onMorePressed;
  const UserListView({
    super.key,
    required this.users,
    required this.onUserTap,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return UserCard(
          user: user,
          onTap: () => onUserTap(user),
          onMorePressed: onMorePressed != null ? () => onMorePressed!(user) : null,
        );
      },
    );
  }
} 