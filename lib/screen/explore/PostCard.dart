import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../models/food.dart';

class PostCard extends StatelessWidget {
  final Food food;

  const PostCard({
    required this.food,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      color: kbackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(food.avatarImage),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.author,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "13/03/2025",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Hình ảnh bài đăng
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            child: Image.asset(
              food.image, // Lấy ảnh từ food
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          // Tên món ăn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              food.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Số lượt thích và bình luận
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Row(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${food.isLiked ? 25 : 10} lượt thích',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.rate_review,
                      color: Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${food.reviews} Người đánh giá',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
