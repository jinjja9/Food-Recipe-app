import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/user_stat_card.dart';
import 'components/user_filter_bar.dart';
import 'components/user_list_view.dart';
import 'components/user_action_sheet.dart';
import 'UserDetailScreen.dart';

import '../recipe/add_recipe_screen.dart';
import 'CategoryManagementScreen.dart';
import 'AllRecipesScreen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedFilter = "Tất cả";

  final List<String> _filterOptions = [
    "Tất cả",
    "Nhiều bài đăng",
    "Mới nhất"
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showUserActionSheet(Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return UserActionSheet(
          user: user,
          onViewDetail: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailScreen(userId: user['uid']),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
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
          title: const Text(
            "Quản lý người dùng",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: UserFilterBar(
                searchController: _searchController,
                filterOptions: _filterOptions,
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
                onSearchChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final users = snapshot.data!.docs;
                final totalUsers = users.length;
                return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('foods').get(),
                  builder: (context, postSnapshot) {
                    final totalPosts = postSnapshot.data?.docs.length ?? 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: UserStatCard(
                        totalPosts: totalPosts,
                        totalUsers: totalUsers,
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final users = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return {
                      ...data,
                      'uid': doc.id,
                    };
                  }).toList();

                  // Lấy số lượng món ăn cho từng user
                  Future<List<Map<String, dynamic>>> getUsersWithFoodCount() async {
                    final foodSnapshot = await FirebaseFirestore.instance.collection('foods').get();
                    final foods = foodSnapshot.docs;
                    return users.map((user) {
                      final userId = user['uid'];
                      final foodCount = foods.where((food) => food['uid'] == userId).length;
                      return {...user, 'foodCount': foodCount};
                    }).toList();
                  }

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: getUsersWithFoodCount(),
                    builder: (context, userSnapshot) {
                      if (!userSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      var userList = userSnapshot.data!;

                      // Sắp xếp theo filter
                      if (_selectedFilter == "Nhiều bài đăng") {
                        userList.sort((a, b) => (b['foodCount'] as int).compareTo(a['foodCount'] as int));
                      } else if (_selectedFilter == "Mới nhất") {
                        userList.sort((a, b) {
                          final aTime = (a['createdAt'] is Timestamp)
                              ? (a['createdAt'] as Timestamp).toDate()
                              : DateTime.tryParse(a['createdAt'].toString()) ?? DateTime(1970);
                          final bTime = (b['createdAt'] is Timestamp)
                              ? (b['createdAt'] as Timestamp).toDate()
                              : DateTime.tryParse(b['createdAt'].toString()) ?? DateTime(1970);
                          return bTime.compareTo(aTime); // Mới nhất lên đầu
                        });
                      }

                      // Lọc theo tên
                      userList = userList.where((user) {
                        final nameMatches = (user['username'] ?? user['name'] ?? '')
                            .toString()
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                        return nameMatches;
                      }).toList();

                      if (userList.isEmpty) {
                        return const Center(
                          child: Text(
                            "Không tìm thấy người dùng nào",
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      }
                      return UserListView(
                        users: userList,
                        onUserTap: (user) => _showUserActionSheet(user),
                        onMorePressed: (user) => _showUserActionSheet(user),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllRecipesScreen(),
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.restaurant_menu),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryManagementScreen(),
                ),
              );
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.category),
          ),
        ],
      ),
    );
  }
}