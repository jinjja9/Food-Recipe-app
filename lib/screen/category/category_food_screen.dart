import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/food.dart';
import '../../widgets/food_card.dart';

class CategoryFoodScreen extends StatefulWidget {
  final String category;
  final List<Food> categoryFoods;

  const CategoryFoodScreen({
    super.key,
    required this.category,
    required this.categoryFoods,
  });

  @override
  State<CategoryFoodScreen> createState() => _CategoryFoodScreenState();
}

class _CategoryFoodScreenState extends State<CategoryFoodScreen> {
  late List<Food> _foods;

  @override
  void initState() {
    super.initState();
    _foods = widget.categoryFoods;
  }

  Future<void> _refreshFoods() async {
    final foodsSnapshot = await FirebaseFirestore.instance
        .collection('foods')
        .where('category', isEqualTo: widget.category)
        .get();
    setState(() {
      _foods = foodsSnapshot.docs.map((doc) => Food.fromFirestore(doc.data(), doc.id)).toList();
    });
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
            title: Text(
              widget.category,
              style: const TextStyle(
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
        child: CustomScrollView(
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
                      food: _foods[index],
                      onFoodUpdated: _refreshFoods,
                    );
                  },
                  childCount: _foods.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
