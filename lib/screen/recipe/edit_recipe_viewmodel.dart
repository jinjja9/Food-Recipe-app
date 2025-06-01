import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/cloudinary_service.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/food.dart';

class EditRecipeViewModel extends ChangeNotifier {
  String selectedCategory;
  String? imageUrl;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> ingredientControllers = [];
  final List<TextEditingController> stepControllers = [];
  final TextEditingController caloController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  bool isUploading = false;
  final String foodId;
  late Stream<DocumentSnapshot> _foodStream;

  List<String> categories = [
    'Món Việt',
    'Món Hàn',
    'Món Nhật',
    'Món Trung',
    'Món Âu',
  ];

  EditRecipeViewModel({required Food food}) : 
    selectedCategory = food.category,
    imageUrl = food.image,
    foodId = food.id {
    _foodStream = FirebaseFirestore.instance
        .collection('foods')
        .doc(foodId)
        .snapshots();
        
    nameController.text = food.name;
    descriptionController.text = food.description;
    caloController.text = food.calories.toString();
    timeController.text = food.cooking_time.toString();
    
    for (var ingredient in food.ingredients) {
      ingredientControllers.add(TextEditingController(text: ingredient));
    }
    
    for (var step in food.steps) {
      stepControllers.add(TextEditingController(text: step));
    }
  }

  Stream<DocumentSnapshot> get foodStream => _foodStream;

  void setCategory(String? newCategory) {
    if (newCategory != null) {
      selectedCategory = newCategory;
      notifyListeners();
    }
  }

  void addIngredient() {
    ingredientControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeIngredient(int index) {
    if (ingredientControllers.length > 1) {
      ingredientControllers[index].dispose();
      ingredientControllers.removeAt(index);
      notifyListeners();
    }
  }

  void addStep() {
    stepControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeStep(int index) {
    if (stepControllers.length > 1) {
      stepControllers[index].dispose();
      stepControllers.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> updateRecipe(BuildContext context) async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        caloController.text.isEmpty ||
        timeController.text.isEmpty ||
        ingredientControllers.any((controller) => controller.text.isEmpty) ||
        stepControllers.any((controller) => controller.text.isEmpty) ||
        imageUrl == null) {
      return false;
    }

    try {
      isUploading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return false;
      }

      final recipeData = {
        'name': nameController.text,
        'description': descriptionController.text,
        'category': selectedCategory,
        'cooking_time': int.tryParse(timeController.text) ?? 0,
        'calories': int.tryParse(caloController.text) ?? 0,
        'ingredients': ingredientControllers.map((controller) => controller.text).toList(),
        'steps': stepControllers.map((controller) => controller.text).toList(),
        'image': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('foods').doc(foodId).update(recipeData);

      isUploading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('Lỗi khi cập nhật công thức: $e');
      isUploading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> pickAndUploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      isUploading = true;
      notifyListeners();

      final file = File(pickedFile.path);
      final uploadUrl = Uri.parse('https://api.cloudinary.com/v1_1/${CloudinaryService.cloudName}/image/upload?folder=${CloudinaryService.folderName}');

      final request = http.MultipartRequest('POST', uploadUrl)
        ..fields['upload_preset'] = CloudinaryService.uploadPreset
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final result = json.decode(responseData);
      
      imageUrl = result['secure_url'];
      isUploading = false;
      notifyListeners();
    } catch (e) {
      print('Error uploading image: $e');
      isUploading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    caloController.dispose();
    timeController.dispose();
    for (var controller in ingredientControllers) {
      controller.dispose();
    }
    for (var controller in stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }
} 