import 'package:flutter/material.dart';

class AddRecipeViewModel extends ChangeNotifier {
  String selectedCategory = 'Món Việt';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> ingredientControllers = [TextEditingController()];
  final List<TextEditingController> stepControllers = [TextEditingController()];
  final TextEditingController caloController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  bool isUploading = false;

  List<String> categories = [
    'Món Việt',
    'Món Hàn',
    'Món Nhật',
    'Món Trung',
    'Món Âu',
  ];

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

  Future<bool> saveRecipe(BuildContext context) async {
    if (nameController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
      isUploading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      isUploading = false;
      notifyListeners();
      return true;
    } else {
      return false;
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