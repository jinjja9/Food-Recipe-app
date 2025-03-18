import 'package:flutter/material.dart';

import '../recipe/add_recipe_screen.dart';
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

    int totalPosts =
        users.fold(0, (sum, user) => sum + int.parse(user['posts']!));
    int totalLikes =
        users.fold(0, (sum, user) => sum + int.parse(user['likes']!));
    double avgPosts = users.isNotEmpty ? totalPosts / users.length : 0;

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
              padding: const EdgeInsets.only(left: 16),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: 30,
            ),
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
            actions: [Container(width: 30)],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddRecipeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Thêm món ăn",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              // Thống kê
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.people,
                          size: 40, color: Colors.blue),
                      title: Text("Tổng số người dùng: ${users.length}"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.post_add,
                          size: 40, color: Colors.green),
                      title: Text("Tổng số bài đăng: $totalPosts"),
                    ),
                    ListTile(
                      leading: const Icon(Icons.analytics,
                          size: 40, color: Colors.orange),
                      title: Text(
                          "Trung bình bài đăng/người: ${avgPosts.toStringAsFixed(2)}"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...users.map((user) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserDetailScreen()),
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
                      trailing: const Icon(Icons.arrow_forward),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
