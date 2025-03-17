import 'package:flutter/material.dart';

import 'UserDetailScreen.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> users = [
      {
        "name": "jacob_w",
        "avatar": "assets/images/avatar1.png",
        "posts": "14",
        "likes": "38"
      },
      {
        "name": "alice_t",
        "avatar": "assets/images/avatar2.png",
        "posts": "9",
        "likes": "25"
      },
      {
        "name": "john_doe",
        "avatar": "assets/images/avatar3.png",
        "posts": "20",
        "likes": "55"
      },
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
            title: const Center(
              child: Text(
                "Danh sách người dùng",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: users.map((user) {
              return GestureDetector(
                onTap: () {
                  // Chuyển sang màn hình chi tiết người dùng
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserDetailScreen(),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(user['avatar']!),
                    ),
                    title: Text(user['name']!),
                    subtitle: Row(
                      children: [
                        Text(
                            "${user['posts']} Bài đăng | ${user['likes']} Lượt thích"),
                      ],
                    ),
                    trailing: Icon(Icons.arrow_forward),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
