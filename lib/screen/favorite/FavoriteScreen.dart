import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/food.dart';
import '../../widgets/food_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Stream<List<Food>> getFoodsStream() {
    return FirebaseFirestore.instance
        .collection('foods')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Food.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Center(
              child: Text(
                "Món ăn yêu thích",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<Food>>(
          stream: getFoodsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có món ăn nào'));
            }
            // Lọc các món ăn yêu thích
            final user = FirebaseAuth.instance.currentUser;
            final uid = user?.uid ?? '';
            final favoriteFoods = snapshot.data!.where((food) => food.likedUsers.contains(uid)).toList();
            
            if (favoriteFoods.isEmpty) {
              return const Center(child: Text('Không có món ăn yêu thích nào'));
            }

            return CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return FoodCard(
                          food: favoriteFoods[index],
                        );
                      },
                      childCount: favoriteFoods.length,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
