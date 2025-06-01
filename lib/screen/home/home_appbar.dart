import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Hôm nay\nnấu món gì?',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              fixedSize: const Size(55, 55)),
          icon: const Icon(Icons.notifications),
        )
      ],
    );
  }
}
