import 'package:app/models/asian_food.dart';
import 'package:app/screen/home/widgets/home_appbar.dart';
import 'package:app/screen/home/widgets/home_search_bar.dart';
import 'package:app/widgets/categories.dart';
import 'package:flutter/material.dart';

import '../../models/food.dart';
import '../../widgets/recommend_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentCat = 'All';
  List<Food> selectedFoods = foods;

  void updateFoodList(String category) {
    setState(() {
      currentCat = category;
      if (category == 'All') {
        selectedFoods = foods;
      } else if (category == 'Món Việt') {
        selectedFoods = foodsAsian;
      } else {
        selectedFoods = [];
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
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Categories(
                currentCat: currentCat,
                onCategorySelected: updateFoodList,
              ),
              const SizedBox(height: 20),
              QuickAndFastList(foods: selectedFoods),
            ],
          ),
        ),
      )),
    );
  }
}
