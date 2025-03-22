import 'package:flutter/material.dart';

import '../../models/category.dart';

class Categories extends StatelessWidget {
  const Categories({
    super.key,
    required this.currentCat,
    required this.onCategorySelected,
    this.limit = 5,
  });

  final String currentCat;
  final Function(String) onCategorySelected;
  final int limit;

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
    // Giới hạn số lượng thể loại hiển thị
    final displayCategories = catgories.take(limit).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          displayCategories.length,
          (index) => GestureDetector(
            onTap: () {
              onCategorySelected(displayCategories[index]);
            },
            child: Container(
              width: 150,
              height: 100,
              margin: const EdgeInsets.only(right: 15),
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
                        _getCategoryImage(displayCategories[index]),
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
                            displayCategories[index],
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
            ),
          ),
        ),
      ),
    );
  }
}
