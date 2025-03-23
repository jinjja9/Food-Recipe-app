import 'package:flutter/material.dart';

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

  final List<Map<String, dynamic>> _users = [
    {
      "name": "jacob_w",
      "avatar": "assets/images/avatar1.png",
      "posts": "14",
      "likes": "38",
      "joinDate": "15/03/2023",
      "status": "active",
      "role": "Người dùng",
    },
    {
      "name": "alice_t",
      "avatar": "assets/images/avatar2.png",
      "posts": "9",
      "likes": "25",
      "joinDate": "22/04/2023",
      "status": "active",
      "role": "Người dùng",
    },
    {
      "name": "john_doe",
      "avatar": "assets/images/avatar3.png",
      "posts": "20",
      "likes": "55",
      "joinDate": "10/01/2023",
      "status": "active",
      "role": "Người dùng",
    },
    {
      "name": "emma_s",
      "avatar": "assets/images/avatar4.png",
      "posts": "7",
      "likes": "19",
      "joinDate": "05/05/2023",
      "status": "inactive",
      "role": "Người dùng",
    },
    {
      "name": "michael_j",
      "avatar": "assets/images/avatar5.png",
      "posts": "16",
      "likes": "42",
      "joinDate": "18/02/2023",
      "status": "active",
      "role": "Người dùng",
    },
    {
      "name": "chef_gordon",
      "avatar": "assets/images/avatar6.png",
      "posts": "32",
      "likes": "128",
      "joinDate": "01/01/2023",
      "status": "active",
      "role": "Đầu bếp",
    },
    {
      "name": "admin_user",
      "avatar": "assets/images/avatar7.png",
      "posts": "5",
      "likes": "17",
      "joinDate": "01/01/2023",
      "status": "active",
      "role": "Admin",
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    return _users.where((user) {
      final nameMatches =
          user["name"].toLowerCase().contains(_searchQuery.toLowerCase());

      if (_selectedFilter == "Tất cả") {
        return nameMatches;
      } else if (_selectedFilter == "Nhiều bài đăng") {
        return nameMatches && int.parse(user["posts"]) >= 10;
      } else if (_selectedFilter == "Nhiều lượt thích") {
        return nameMatches && int.parse(user["likes"]) >= 30;
      } else if (_selectedFilter == "Mới nhất") {
        // Giả sử ngày tham gia có định dạng dd/mm/yyyy
        final parts = user["joinDate"].split('/');
        final joinDate = DateTime(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
        final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
        return nameMatches && joinDate.isAfter(oneMonthAgo);
      }
      return nameMatches;
    }).toList();
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
                      builder: (context) => const UserDetailScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text("Chỉnh sửa thông tin"),
                onTap: () {
                  Navigator.pop(context);
                  // Hiển thị form chỉnh sửa thông tin
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
                    setState(() {
                      user["status"] = "active";
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Đã mở khóa tài khoản ${user["name"]}"),
                        backgroundColor: Colors.green,
                      ),
                    );
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
        content:
            Text("Bạn có chắc chắn muốn khóa tài khoản ${user["name"]} không?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                user["status"] = "inactive";
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Đã khóa tài khoản ${user["name"]}"),
                  backgroundColor: Colors.orange,
                ),
              );
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
          "Bạn có chắc chắn muốn xóa tài khoản ${user["name"]} không? "
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
            onPressed: () {
              setState(() {
                _users.remove(user);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Đã xóa tài khoản ${user["name"]}"),
                  backgroundColor: Colors.red,
                ),
              );
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

  @override
  Widget build(BuildContext context) {
    int totalPosts =
        _users.fold(0, (sum, user) => sum + int.parse(user['posts']!));
    int totalLikes =
        _users.fold(0, (sum, user) => sum + int.parse(user['likes']!));
    double avgPosts = _users.isNotEmpty ? totalPosts / _users.length : 0;

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
            // Thanh tìm kiếm và bộ lọc
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

            // Thống kê
            Padding(
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
                        _users.length.toString(),
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
            ),

            const SizedBox(height: 16),

            // Danh sách người dùng
            Expanded(
              child: filteredUsers.isEmpty
                  ? const Center(
                      child: Text(
                        "Không tìm thấy người dùng nào",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];
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
                                    backgroundImage:
                                        AssetImage(user['avatar']!),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              user['name']!,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            _buildRoleBadge(user['role']),
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
                                              "Tham gia: ${user['joinDate']}",
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
                                              "${user['posts']} bài đăng",
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            const SizedBox(width: 16),
                                            Text(
                                              "${user['likes']} lượt thích",
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      _buildStatusBadge(user['status']),
                                      const SizedBox(height: 8),
                                      IconButton(
                                        icon: const Icon(Icons.more_vert),
                                        onPressed: () =>
                                            _showUserActionSheet(user),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
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
      case "Admin":
        color = Colors.red;
        break;
      case "Đầu bếp":
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
        role,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
