import 'package:app/models/vietnam_food.dart';
import 'package:app/screen/home/categories.dart';
import 'package:app/screen/home/widgets/home_appbar.dart';
import 'package:app/screen/home/widgets/home_search_bar.dart';
import 'package:flutter/material.dart';

import '../../models/asian_food.dart';
import '../../models/eupore_food.dart';
import '../../models/food.dart';
import 'widgets/recommend_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentCat = 'Món Việt';
  List<Food> selectedFoods = foods;

  void updateFoodList(String category) {
    setState(() {
      currentCat = category;
      if (category == 'Món Âu') {
        selectedFoods = foods;
      } else if (category == 'Món Việt') {
        selectedFoods = foodsVietNam;
      } else if (category == 'Món Trung') {
        selectedFoods = foodsAsian;
      } else {
        selectedFoods = foodsEupore;
      }
    });
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
              const Text(
                'Thể loại',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Categories(
                currentCat: currentCat,
                onCategorySelected: updateFoodList,
              ),
              const SizedBox(height: 20),
              RecommendListList(foods: selectedFoods),
            ],
          ),
        ),
      )),
    );
  }
}
