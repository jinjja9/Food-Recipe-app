import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../explore/ExploreScreen.dart';
import '../favorite/FavoriteScreen.dart';
import '../profile/ProfileScreen.dart';
import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  final String userId;
  const MainScreen({super.key, required this.userId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    List screens = [
      const HomeScreen(),
      const ExploreScreen(),
      const FavoriteScreen(),
      ProfileScreen(userId: widget.userId),
    ];

    return Scaffold(
      body: screens[currentTab],
      bottomNavigationBar: Container(
        height: 75,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: SalomonBottomBar(
            currentIndex: currentTab,
            onTap: (i) => setState(() => currentTab = i),
            backgroundColor: Colors.white,
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_rounded, size: 28),
                title: const Text("Trang chủ", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.indigo[400],
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.explore_rounded, size: 28),
                title: const Text("Khám phá", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.orangeAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.favorite_rounded, size: 28),
                title: const Text("Yêu thích", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.pinkAccent,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person_rounded, size: 28),
                title: const Text("Cá nhân", style: TextStyle(fontSize: 14)),
                selectedColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
