import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../recipe/add_recipe_screen.dart';
import 'CategoryManagementScreen.dart';
import 'UserDetailScreen.dart';

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
    "Nhiều lượt thích",
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
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text("Xem chi tiết"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserDetailScreen(userId: user['uid']),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text("Chỉnh sửa thông tin"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              if (user["status"] == "active")
                ListTile(
                  leading: const Icon(Icons.block, color: Colors.red),
                  title: const Text("Khóa tài khoản"),
                  onTap: () {
                    Navigator.pop(context);
                    _showBlockUserDialog(user);
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: const Text("Mở khóa tài khoản"),
                  onTap: () {
                    Navigator.pop(context);
                    _updateUserStatus(user, "active");
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text("Xóa tài khoản"),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteUserDialog(user);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBlockUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Khóa tài khoản"),
        content: Text("Bạn có chắc chắn muốn khóa tài khoản ${user["username"]} không?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              _updateUserStatus(user, "inactive");
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Khóa"),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xóa tài khoản"),
        content: Text(
          "Bạn có chắc chắn muốn xóa tài khoản ${user["username"]} không? "
          "Hành động này không thể hoàn tác và tất cả dữ liệu của người dùng sẽ bị xóa.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user['uid'])
                    .delete();
                
                await FirebaseAuth.instance
                    .currentUser?.delete();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xóa tài khoản ${user["username"]}')),
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
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text("Xóa"),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUserStatus(Map<String, dynamic> user, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user['uid'])
          .update({'status': status});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(status == "active" 
                ? "Đã mở khóa tài khoản ${user["username"]}"
                : "Đã khóa tài khoản ${user["username"]}"),
            backgroundColor: status == "active" ? Colors.green : Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi cập nhật trạng thái: $e')),
        );
      }
    }
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
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Tìm kiếm người dùng...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        "Lọc:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _filterOptions.map((filter) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(filter),
                                  selected: _selectedFilter == filter,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedFilter = filter;
                                      });
                                    }
                                  },
                                  selectedColor: Colors.blue.shade100,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
                final totalPosts = users.fold<int>(
                  0,
                  (sum, doc) => sum +  0,
                );
                final totalLikes = users.fold<int>(
                  0,
                  (sum, doc) => sum +  0,
                );
                final avgPosts = totalUsers > 0 ? totalPosts / totalUsers : 0;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            Icons.people,
                            Colors.blue,
                            totalUsers.toString(),
                            "Người dùng",
                          ),
                          _buildStatItem(
                            Icons.post_add,
                            Colors.green,
                            totalPosts.toString(),
                            "Bài đăng",
                          ),
                          _buildStatItem(
                            Icons.favorite,
                            Colors.red,
                            totalLikes.toString(),
                            "Lượt thích",
                          ),
                          _buildStatItem(
                            Icons.analytics,
                            Colors.orange,
                            avgPosts.toStringAsFixed(1),
                            "TB bài/người",
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  }).where((user) {
                    final nameMatches = user['username']
                        .toString()
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());

                    if (_selectedFilter == "Tất cả") {
                      return nameMatches;
                    } else if (_selectedFilter == "Nhiều bài đăng") {
                      return nameMatches && (user['posts'] ?? 0) >= 10;
                    } else if (_selectedFilter == "Nhiều lượt thích") {
                      return nameMatches && (user['likes'] ?? 0) >= 30;
                    } else if (_selectedFilter == "Mới nhất") {
                      final createdAt = (user['createdAt'] as Timestamp?)?.toDate();
                      if (createdAt == null) return false;
                      final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
                      return nameMatches && createdAt.isAfter(oneMonthAgo);
                    }
                    return nameMatches;
                  }).toList();

                  if (users.isEmpty) {
                    return const Center(
                      child: Text(
                        "Không tìm thấy người dùng nào",
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showUserActionSheet(user),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(user['avatar'] ?? 'assets/images/avatar1.png'),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            user['username'] ?? 'Unknown',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          _buildRoleBadge(user['role'] ?? 'user'),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 14,
                                              color: Colors.grey.shade600),
                                          const SizedBox(width: 4),
                                          Text(
                                            "Tham gia: ${(user['createdAt'] as Timestamp?)?.toDate().toString().split(' ')[0] ?? 'N/A'}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            "${user['posts'] ?? 0} bài đăng",
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(width: 16),
                                          Text(
                                            "${user['likes'] ?? 0} lượt thích",
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    _buildStatusBadge(user['status'] ?? 'active'),
                                    const SizedBox(height: 8),
                                    IconButton(
                                      icon: const Icon(Icons.more_vert),
                                      onPressed: () => _showUserActionSheet(user),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
                  builder: (context) => const AddRecipeScreen(),
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

  Widget _buildStatItem(
      IconData icon, Color color, String value, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    if (status == "active") {
      color = Colors.green;
      label = "Hoạt động";
    } else {
      color = Colors.red;
      label = "Bị khóa";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRoleBadge(String role) {
    Color color;

    switch (role) {
      case "admin":
        color = Colors.red;
        break;
      case "chef":
        color = Colors.purple;
        break;
      default:
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        role == "admin" ? "Admin" : role == "chef" ? "Đầu bếp" : "Người dùng",
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
