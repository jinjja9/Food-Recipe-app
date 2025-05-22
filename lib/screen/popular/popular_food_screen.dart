import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/food.dart';
import '../../widgets/food_card.dart';

class PopularFoodScreen extends StatelessWidget {
  const PopularFoodScreen({super.key, required List popularFoods});

  Future<List<Food>> fetchPopularFoods() async {
    final snapshot = await FirebaseFirestore.instance.collection('foods').get();
    return snapshot.docs.map((doc) => Food.fromFirestore(doc.data(), doc.id)).toList();
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
            title: const Text(
              "Món ăn phổ biến",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            automaticallyImplyLeading: true,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Food>>(
          future: fetchPopularFoods(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có món ăn nào'));
            }
            final foods = snapshot.data!;
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
                        return FoodCard(food: foods[index]);
                      },
                      childCount: foods.length,
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
