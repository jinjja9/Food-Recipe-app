import 'package:app/models/vietnam_food.dart';
import 'package:app/screen/home/home_appbar.dart';
import 'package:app/screen/home/home_search_bar.dart';
import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../models/asian_food.dart';
import '../../models/eupore_food.dart';
import '../../models/food.dart';
import '../../widgets/food_card.dart';
import '../category/all_categories_screen.dart';
import '../category/categories.dart';
import '../category/category_food_screen.dart';
import '../popular/popular_food_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentCat = 'Món Âu';
  List<Food> selectedFoods = foods;

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
                          // Điều hướng đến màn hình tất cả thể loại
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
                onCategorySelected: (category) {
                  setState(() {
                    currentCat = category;
                  });

                  // Điều hướng đến màn hình CategoryFoodScreen với món ăn cố định
                  List<Food> categoryFoods = foods; // Giữ dữ liệu cố định
                  if (category == 'Món Việt') {
                    categoryFoods = foodsVietNam;
                  } else if (category == 'Món Trung') {
                    categoryFoods = foodsAsian;
                  } else if (category == 'Món Nhật') {
                    categoryFoods = foodsEupore;
                  }

                  // Chuyển đến màn hình CategoryFoodScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryFoodScreen(
                        category: category,
                        categoryFoods: categoryFoods,
                      ),
                    ),
                  );
                },
                limit: 5, // Giới hạn hiển thị 5 thể loại
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
                              builder: (context) => PopularFoodScreen(
                                popularFoods:
                                    foods, // Truyền tất cả món ăn phổ biến
                              ),
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
              const SizedBox(height: 20),
              // Grid hiển thị 4 món ăn phổ biến, sử dụng dữ liệu cố định từ `foods`
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio:
                      0.75, // Điều chỉnh tỷ lệ khung hình của card
                ),
                itemCount: selectedFoods.length > 4 ? 4 : selectedFoods.length,
                // Giới hạn 4 món
                itemBuilder: (context, index) {
                  return FoodCard(food: selectedFoods[index]);
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
