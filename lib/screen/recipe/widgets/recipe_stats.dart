import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../models/food.dart';
import '../../../widgets/liked_users_dialog.dart';

class RecipeStats extends StatelessWidget {
  final Food food;

  const RecipeStats({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.local_fire_department_rounded,
            value: "${food.calories}",
            label: "Calo",
            color: Colors.orange,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.timer_rounded,
            value: "${food.cooking_time}",
            label: "Phút",
            color: Colors.blue,
          ),
          _buildDivider(),
          _buildStatItem(
            icon: Icons.favorite,
            value: "${food.likedUsers.length}",
            label: "Lượt thích",
            color: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => LikedUsersDialog(
                  likedUserIds: food.likedUsers,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
} 