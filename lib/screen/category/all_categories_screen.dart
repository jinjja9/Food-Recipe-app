import 'package:flutter/material.dart';

import '../../models/asian_food.dart';
import '../../models/category.dart';
import '../../models/eupore_food.dart';
import '../../models/food.dart';
import '../../models/vietnam_food.dart';
import 'category_food_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  String _getCategoryImage(String category) {
    switch (category) {
      case "Món Âu":
        return 'assets/images/butter.jpg';
      case "Món Việt":
        return 'assets/images/banh_cuon.png';
      case "Món Hàn":
        return 'assets/images/tokbokki.png';
      case "Món Nhật":
        return 'assets/images/ramen.jpg';
      case "Món Trung":
        return 'assets/images/ha_cao.png';
      default:
        return 'assets/images/food.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tất cả thể loại',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hiển thị tất cả các thể loại dưới dạng grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.5, // Điều chỉnh tỷ lệ khung hình
                ),
                itemCount: catgories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Điều hướng đến màn CategoryFoodScreen khi nhấn vào thể loại
                      List<Food> categoryFoods = foods; // Giữ dữ liệu cố định
                      if (catgories[index] == 'Món Việt') {
                        categoryFoods = foodsVietNam;
                      } else if (catgories[index] == 'Món Trung') {
                        categoryFoods = foodsAsian;
                      } else if (catgories[index] == 'Món Nhật') {
                        categoryFoods = foodsEupore;
                      }

                      // Chuyển đến màn hình CategoryFoodScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryFoodScreen(
                            category: catgories[index],
                            categoryFoods: categoryFoods,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Hình ảnh nền
                            Image.asset(
                              _getCategoryImage(catgories[index]),
                              fit: BoxFit.cover,
                            ),
                            // Tiêu đề ở dưới cùng
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                color: Colors.black.withOpacity(0.6),
                                child: Text(
                                  catgories[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
