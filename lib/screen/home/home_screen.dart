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

  Future<List<Food>> fetchFoods() async {
    final snapshot = await FirebaseFirestore.instance.collection('foods').get();
    print('Số lượng món ăn lấy được: \\${snapshot.docs.length}');
    return snapshot.docs.map((doc) => Food.fromFirestore(doc.data(), doc.id)).toList();
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
              FutureBuilder<List<Food>>(
                future: fetchFoods(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có món ăn nào'));
                  }
                  final foods = snapshot.data!;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return FoodCard(food: food);
                    },
                  );
                },
              )

            ],
          ),
        ),
      )),
    );
  }
}
