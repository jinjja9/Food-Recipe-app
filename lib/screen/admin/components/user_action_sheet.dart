import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserActionSheet extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onViewDetail;
  final VoidCallback? onEdit;
  final VoidCallback? onBlock;
  final VoidCallback? onUnblock;
  final VoidCallback? onDelete;
  const UserActionSheet({
    super.key,
    required this.user,
    this.onViewDetail,
    this.onEdit,
    this.onBlock,
    this.onUnblock,
    this.onDelete,
  });

  void _showRoleDialog(BuildContext context) async {
    String? selectedRole = user['role'];
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Phân quyền'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Người dùng'),
                value: 'user',
                groupValue: selectedRole,
                onChanged: (value) {
                  selectedRole = value;
                  Navigator.of(context).pop();
                  _updateRole(context, value!);
                },
              ),
              RadioListTile<String>(
                title: const Text('Admin'),
                value: 'admin',
                groupValue: selectedRole,
                onChanged: (value) {
                  selectedRole = value;
                  Navigator.of(context).pop();
                  _updateRole(context, value!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateRole(BuildContext context, String newRole) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user['uid'])
          .update({'role': newRole});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã cập nhật quyền thành ${newRole == 'admin' ? 'Admin' : 'Người dùng'}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật quyền: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: const Text("Xem chi tiết"),
            onTap: onViewDetail,
          ),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.purple),
            title: const Text("Phân quyền"),
            onTap: () => _showRoleDialog(context),
          ),
          if (user["status"] == "active")
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text("Khóa tài khoản"),
              onTap: onBlock,
            ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Xóa tài khoản"),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
} 