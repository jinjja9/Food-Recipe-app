import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/food.dart';
import '../../models/user.dart' as app_model;
import '../profile/PersonalFoodCard.dart';
import '../recipe/recipe_screen.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;
  
  const UserDetailScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<app_model.User?> _userDataFuture;
  late Future<List<Food>> _foodsFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
    _foodsFuture = fetchFoods();
  }

  Future<app_model.User?> _getUserData() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    if (!doc.exists) return null;
    return app_model.User.fromFirestore(doc.id, doc.data()!);
  }

  Future<List<Food>> fetchFoods() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('foods')
        .where('userId', isEqualTo: widget.userId)
        .get();
    return snapshot.docs.map((doc) => Food.fromFirestore(doc.data(), doc.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
            ),
            title: const Center(
              child: Text(
                "Hồ Sơ",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(left: 16.0),
                width: 30,
              ),
            ],
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                FutureBuilder<app_model.User?>(
                  future: _userDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('Không tìm thấy thông tin người dùng'));
                    }

                    final user = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: user.avatarImage.isNotEmpty 
                              ? NetworkImage(user.avatarImage) as ImageProvider
                              : const AssetImage('assets/images/avatar1.png'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '@${user.name}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (user.displayName != null) ...[
                          const SizedBox(height: 5),
                          Text(
                            user.displayName!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Xóa tài khoản'),
                              content: const Text('Bạn có chắc chắn muốn xóa tài khoản này không?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.userId)
                                  .delete();
                              
                              await FirebaseAuth.instance
                                  .currentUser?.delete();

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Đã xóa tài khoản thành công')),
                                );
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Lỗi khi xóa tài khoản: $e')),
                                );
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Xóa tài khoản người dùng"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Danh sách món ăn",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Food>>(
                  future: _foodsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Không có món ăn nào'));
                    }
                    final foods = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: foods.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeScreen(food: foods[index]),
                              ),
                            );
                          },
                          child: PersonalFoodCard(food: foods[index]),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label),
      ],
    );
  }
}
