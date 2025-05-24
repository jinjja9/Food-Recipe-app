import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/food.dart';
import '../screen/recipe/recipe_screen.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  final Function()? onFoodUpdated;

  const FoodCard({
    super.key, 
    required this.food,
    this.onFoodUpdated,
  });

  @override
  Widget build(BuildContext context) {
    print(Firebase.app().options.projectId);
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';
    final isLiked = food.likedUsers.contains(uid);
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeScreen(
              food: food,
              onFoodUpdated: onFoodUpdated,
            ),
          ),
        );
        // Gọi callback khi quay lại từ RecipeScreen
        if (onFoodUpdated != null) {
          onFoodUpdated!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(food.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Phần nội dung
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tên món ăn
                      Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Mô tả món ăn
                      Text(
                        food.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 15),
                      // Thời gian và đánh giá
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Thời gian
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "${food.cooking_time} phút",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          // Đánh giá
                          Row(
                            children: [
                              Icon(Icons.star,
                                  size: 14, color: Colors.orange[400]),
                              const SizedBox(width: 4),
                              Text(
                                "${food.calories} cal",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Nút yêu thích
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user == null) return;
                    final uid = user.uid;
                    final foodRef = FirebaseFirestore.instance.collection('foods').doc(food.id);
                    List<String> likedUsers = List<String>.from(food.likedUsers);
                    bool isLiked = likedUsers.contains(uid);
                    if (isLiked) {
                      likedUsers.remove(uid);
                    } else {
                      likedUsers.add(uid);
                    }
                    await foodRef.update({'likedUsers': likedUsers});
                    food.likedUsers = likedUsers;
                    (context as Element).markNeedsBuild();
                    if (onFoodUpdated != null) {
                      onFoodUpdated!();
                    }
                  },
                  padding: EdgeInsets.zero,
                  iconSize: 18,
                  icon: isLiked
                      ? const Icon(Icons.favorite, color: Colors.red)
                      : const Icon(Icons.favorite_border, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
