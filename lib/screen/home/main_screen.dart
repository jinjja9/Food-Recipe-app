import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../explore/ExploreScreen.dart';
import '../favorite/FavoriteScreen.dart';
import '../profile/ProfileScreen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;
  List screens = const [
    HomeScreen(),
    FavoriteScreen(),
    ExploreScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentTab,
        onTap: (i) => setState(() {
          currentTab = i;
        }),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home),
            title: Text("Trang chủ"),
            selectedColor: Colors.indigo[400],
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Yêu thích"),
            selectedColor: Colors.indigo[400],
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.explore),
            title: Text("Khám phá"),
            selectedColor: Colors.indigo[400],
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.settings),
            title: Text("Cá nhân"),
            selectedColor: Colors.indigo[400],
          ),
        ],
      ),
      body: screens[currentTab],
    );
  }
}
