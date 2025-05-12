import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudinaryService {
  static const String cloudName = 'dpv1ucjbh';
  static const String uploadPreset = 'up_load_r1ynblw1';
  static const String folderName = 'Food';  // Folder ảnh sẽ được lưu vào

  static Future<void> pickAndUploadImage() async {
    // Sử dụng ImagePicker để chọn ảnh từ thư viện
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload?folder=$folderName');

    // Chuẩn bị multipart request để tải ảnh lên Cloudinary
    final request = http.MultipartRequest('POST', uploadUrl)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    // Gửi request và xử lý phản hồi
    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final result = json.decode(responseData);
    final imageUrl = result['secure_url'];  // Lấy URL ảnh đã upload

    // Lưu URL vào Firestore (dưới collection 'images')
    await FirebaseFirestore.instance.collection('images').add({
      'url': imageUrl,
      'uploadedAt': Timestamp.now(),
    });

    print('Image uploaded successfully: $imageUrl');
  }
}
