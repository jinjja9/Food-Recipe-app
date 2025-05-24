import 'package:app/screen/home/home_appbar.dart';
import 'package:app/screen/home/home_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/color.dart';
import '../../models/food.dart';
import '../../widgets/food_card.dart';
import '../category/all_categories_screen.dart';
import '../../models/categories.dart';
import '../category/category_food_screen.dart';
import '../popular/popular_food_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentCat = 'Món Âu';
  List<Food> _foods = [];

  Future<List<Food>> fetchFoods() async {
    final snapshot = await FirebaseFirestore.instance.collection('foods').get();
    print('Số lượng món ăn lấy được: \\${snapshot.docs.length}');
    final foods = snapshot.docs.map((doc) => Food.fromFirestore(doc.data(), doc.id)).toList();
    foods.sort((a, b) => b.likes.compareTo(a.likes));
    return foods.take(4).toList();
  }

  Future<void> _refreshFoods() async {
    final foods = await fetchFoods();
    setState(() {
      _foods = foods;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeAppbar(),
              const SizedBox(height: 20),
              const HomeSearchBar(),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/explore.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thể loại',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AllCategoriesScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Xem tất cả',
                          style:
                              TextStyle(color: backgroundButton, fontSize: 15),
                        )),
                  ),
                ],
              ),
              Categories(
                currentCat: currentCat,
                onCategorySelected: (categoryName) async {
                  final foodsSnapshot = await FirebaseFirestore.instance
                      .collection('foods')
                      .where('category', isEqualTo: categoryName)
                      .get();
                  final foods = foodsSnapshot.docs.map((doc) => Food.fromFirestore(doc.data(),doc.id)).toList();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryFoodScreen(
                        category: categoryName,
                        categoryFoods: foods,
                      ),
                    ),
                  );
                },
                limit: 5,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Phổ biến',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PopularFoodScreen(popularFoods: [],),
                          ),
                        );
                      },
                      child: const Text(
                        'Xem tất cả',
                        style: TextStyle(color: backgroundButton, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('foods').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final foods = snapshot.data!.docs
                      .map((doc) => Food.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
                      .toList();
                  foods.sort((a, b) => b.likes.compareTo(a.likes));
                  final topFoods = foods.take(4).toList();
                  if (topFoods.isEmpty) {
                    return const Center(child: Text('Không có món ăn phổ biến'));
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: topFoods.length,
                    itemBuilder: (context, index) {
                      final food = topFoods[index];
                      return FoodCard(
                        food: food,
                        onFoodUpdated: _refreshFoods,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
