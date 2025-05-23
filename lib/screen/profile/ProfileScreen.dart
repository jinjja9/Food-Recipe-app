import 'package:app/screen/profile/EditProfileScreen.dart';
import 'package:app/screen/sign_in_up/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/color.dart';
import '../../models/food.dart';
import '../admin/UserListScreen.dart';
import '../recipe/recipe_screen.dart';
import 'PersonalFoodCard.dart';
import '../../models/user.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<User?> _userFuture;
  late Future<List<Food>> _foodsFuture;
  late Future<List<User>> _followingFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser();
    _foodsFuture = fetchAllFoods();
    _followingFuture = fetchFollowing();
  }

  Future<User?> fetchUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    if (!doc.exists) return null;
    return User.fromFirestore(doc.id, doc.data()!);
  }

  Future<List<Food>> fetchAllFoods() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('foods')
        .where('uid', isEqualTo: widget.userId)
        .get();
    return snapshot.docs.map((doc) => Food.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<List<User>> fetchFollowing() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('followers', arrayContains: widget.userId)
        .get();
    return snapshot.docs.map((doc) => User.fromFirestore(doc.id, doc.data())).toList();
  }

  void showUserListDialog(BuildContext context, List<User> users, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: users.isEmpty
              ? const Text('Không có người dùng nào')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: u.avatarImage.isNotEmpty
                            ? NetworkImage(u.avatarImage)
                            : const AssetImage('assets/images/avatar1.png') as ImageProvider,
                      ),
                      title: Text(u.name),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
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
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(child: Text('Không tìm thấy thông tin user'));
          }
          final user = userSnapshot.data!;
          return FutureBuilder<List<Food>>(
            future: _foodsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final foods = snapshot.data ?? [];
              final postCount = foods.length;
              return FutureBuilder<List<User>>(
                future: _followingFuture,
                builder: (context, followingSnapshot) {
                  final following = followingSnapshot.data ?? [];
                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              backgroundButton,
                                              backgroundButton.withOpacity(0.8),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 58,
                                            backgroundImage: user.avatarImage.startsWith('http')
                                                ? NetworkImage(user.avatarImage) as ImageProvider
                                                : AssetImage('assets/images/avatar1.png'),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 5,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: const BoxDecoration(
                                              color: backgroundButton,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "@${user.name}",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildProfileStat(postCount.toString(), 'Bài đăng'),
                                    const SizedBox(width: 30),
                                    GestureDetector(
                                      onTap: () {
                                        showUserListDialog(context, following, 'Đang theo dõi');
                                      },
                                      child: _buildProfileStat(following.length.toString(), 'Đang theo dõi'),
                                    ),
                                    const SizedBox(width: 30),
                                    GestureDetector(
                                      onTap: () async {
                                        final followerIds = user.followers;
                                        final followers = await Future.wait(
                                          followerIds.map((id) async {
                                            final doc = await FirebaseFirestore.instance.collection('users').doc(id).get();
                                            if (!doc.exists) return null;
                                            return User.fromFirestore(doc.id, doc.data()!);
                                          }),
                                        );
                                        showUserListDialog(context, followers.whereType<User>().toList(), 'Lượt theo dõi');
                                      },
                                      child: _buildProfileStat(user.followers.length.toString(), 'Lượt theo dõi'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditProfileScreen(userId: widget.userId),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kprimaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text("Chỉnh sửa thông tin"),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SignInScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: kprimaryColor,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text("Đăng xuất"),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const UserListScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kprimaryColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text("Danh sách người dùng"),
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
                            const Text(
                              "Danh sách món ăn của tôi",
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            foods.isEmpty
                                ? const Center(child: Text('Bạn chưa có món ăn nào'))
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                    ),
                                    itemCount: foods.length,
                                    itemBuilder: (context, index) {
                                      final food = foods[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RecipeScreen(
                                                food: food,
                                              ),
                                            ),
                                          );
                                        },
                                        child: PersonalFoodCard(food: food),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
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
