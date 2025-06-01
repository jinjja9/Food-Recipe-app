import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudinaryService {
  static const String cloudName = 'dpv1ucjbh';
  static const String uploadPreset = 'up_load_r1ynblw1';
  static const String folderName = 'Food';

  static Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final file = File(pickedFile.path);
    final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload?folder=$folderName');

    final request = http.MultipartRequest('POST', uploadUrl)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseData = await response.stream.bytesToString();
    final result = json.decode(responseData);
    final imageUrl = result['secure_url'];

    await FirebaseFirestore.instance.collection('images').add({
      'url': imageUrl,
      'uploadedAt': Timestamp.now(),
    });

    print('Image uploaded successfully: $imageUrl');
  }
}
