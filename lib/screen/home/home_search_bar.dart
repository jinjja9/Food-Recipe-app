import 'package:flutter/material.dart';
import 'search_screen.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: const Row(
          children: [
            Icon(Icons.search),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Tìm kiếm công thức',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
