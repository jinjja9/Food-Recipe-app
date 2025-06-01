import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/user.dart' as app_model;
import '../../services/cloudinary_service.dart';

import '../../core/color.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;
  final Function()? onProfileUpdated;
  const EditProfileScreen({
    super.key, 
    required this.userId,
    this.onProfileUpdated,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isEdited = false;
  bool _isUploading = false;
  String? _newAvatarUrl;

  late Future<app_model.User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = fetchUser();
    _nameController.addListener(_checkEdited);
    _usernameController.addListener(_checkEdited);
    _emailController.addListener(_checkEdited);
    _bioController.addListener(_checkEdited);
    _passwordController.addListener(_checkEdited);
    _confirmPasswordController.addListener(_checkEdited);
  }

  Future<app_model.User?> fetchUser() async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
    if (!doc.exists) return null;
    return app_model.User.fromFirestore(doc.id, doc.data()!);
  }

  void _checkEdited() {
    setState(() {
      _isEdited = _nameController.text != '' ||
          _usernameController.text != '' ||
          _emailController.text != '' ||
          _bioController.text != '' ||
          _passwordController.text.isNotEmpty ||
          _confirmPasswordController.text.isNotEmpty ||
          _newAvatarUrl != null;
    });
  }

  Future<void> _pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      setState(() {
        _isUploading = true;
      });

      final file = File(pickedFile.path);
      final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/${CloudinaryService.cloudName}/image/upload?folder=${CloudinaryService.folderName}');

      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = CloudinaryService.uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);
      
      setState(() {
        _newAvatarUrl = result['secure_url'];
        _isUploading = false;
        _isEdited = true;
      });
    } catch (e) {
      print('Lỗi khi tải ảnh lên: $e');
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra khi tải ảnh lên'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveChanges() async {
    try {
      final updates = <String, dynamic>{};
      
      if (_nameController.text.isNotEmpty) {
        updates['name'] = _nameController.text;
      }
      if (_emailController.text.isNotEmpty) {
        updates['email'] = _emailController.text;
      }
      if (_bioController.text.isNotEmpty) {
        updates['bio'] = _bioController.text;
      }
      if (_newAvatarUrl != null) {
        updates['avatarImage'] = _newAvatarUrl;
      }

      if (updates.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update(updates);
            
        // Gọi callback để thông báo cho ProfileScreen
        if (widget.onProfileUpdated != null) {
          widget.onProfileUpdated!();
        }
      }

      _showSuccessDialog();
    } catch (e) {
      print('Lỗi khi lưu thay đổi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Có lỗi xảy ra khi lưu thay đổi'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Chỉnh sửa thông tin",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: backgroundButton),
        actions: [
          TextButton(
            onPressed: _isEdited
                ? () {
                    _saveChanges();
                  }
                : null,
            child: Text(
              "Lưu",
              style: TextStyle(
                color: _isEdited ? backgroundButton : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: _isUploading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: backgroundButton),
                  SizedBox(height: 16),
                  Text(
                    "Đang tải ảnh lên...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : FutureBuilder<app_model.User?>(
              future: _userFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: backgroundButton),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                    child: Text(
                      'Không tìm thấy thông tin người dùng',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
                final user = snapshot.data!;
                // Gán dữ liệu vào controller nếu chưa gán
                if (_nameController.text.isEmpty && _usernameController.text.isEmpty && _emailController.text.isEmpty) {
                  _usernameController.text = user.name;
                  _emailController.text = user.email;
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Column(
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
                                        backgroundImage: _newAvatarUrl != null
                                            ? NetworkImage(_newAvatarUrl!) as ImageProvider
                                            : (user.avatarImage.isNotEmpty
                                                ? NetworkImage(user.avatarImage) as ImageProvider
                                                : const AssetImage('assets/images/avatar1.png')),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _pickAndUploadImage,
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
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _pickAndUploadImage,
                              child: const Text(
                                "Thay đổi ảnh đại diện",
                                style: TextStyle(
                                  color: backgroundButton,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Thông tin cá nhân",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _usernameController,
                              label: "Tên người dùng",
                              hint: "Nhập tên người dùng của bạn",
                              icon: Icons.alternate_email,
                              prefix: "@",
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _emailController,
                              label: "Email",
                              hint: "Nhập email của bạn",
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Đổi mật khẩu",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildTextField(
                              controller: _passwordController,
                              label: "Mật khẩu mới",
                              hint: "Nhập mật khẩu mới của bạn",
                              icon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              onToggleVisibility: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            const SizedBox(height: 15),
                            _buildTextField(
                              controller: _confirmPasswordController,
                              label: "Xác nhận mật khẩu",
                              hint: "Nhập lại mật khẩu của bạn",
                              icon: Icons.lock_outline,
                              obscureText: _obscureConfirmPassword,
                              onToggleVisibility: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: () {
                              _showDeleteAccountDialog();
                            },
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            label: const Text(
                              "Xóa tài khoản",
                              style: TextStyle(
                                fontSize: 16
                                ,color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? prefix,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: backgroundButton, width: 1.5),
          ),
          prefixIcon: Icon(icon, color: kprimaryColor),
          prefixText: prefix,
          suffixIcon: onToggleVisibility != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Cập nhật thành công!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Thông tin của bạn đã được cập nhật thành công.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        backgroundButton,
                        backgroundButton.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Đồng ý",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Xóa tài khoản?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Bạn có chắc chắn muốn xóa tài khoản? Hành động này không thể hoàn tác và tất cả dữ liệu của bạn sẽ bị mất.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text("Hủy"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text("Xóa"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
