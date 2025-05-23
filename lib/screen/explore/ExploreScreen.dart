import 'package:app/screen/recipe/add_recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/food.dart';
import '../recipe/recipe_screen.dart';
import 'PostCard.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Future<List<Food>> fetchFoods() async {
    final snapshot = await FirebaseFirestore.instance.collection('foods').orderBy('createdAt',descending: true).get();
    return snapshot.docs.map((doc) => Food.fromFirestore(doc.data(), doc.id)).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              floating: true,
              pinned: true,
              title: const Text(
                "Khám phá",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline,
                      color: Colors.orange, size: 28),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddRecipeScreen()),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 8),
              sliver: FutureBuilder<List<Food>>(
                future: fetchFoods(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Text('Không có món ăn nào')),
                    );
                  }
                  final foods = snapshot.data!;
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final food = foods[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeScreen(food: food),
                            ),
                          ),
                          child: PostCard(food: food),
                        );
                      },
                      childCount: foods.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
