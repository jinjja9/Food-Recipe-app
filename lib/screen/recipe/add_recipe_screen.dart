import 'package:flutter/material.dart';

import '../../core/color.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen>
    with SingleTickerProviderStateMixin {
  String selectedCategory = 'Món Việt';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> ingredientControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> stepControllers = [TextEditingController()];
  final TextEditingController caloController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  bool isUploading = false;
  late TabController _tabController;

  List<String> categories = [
    'Món Việt',
    'Món Hàn',
    'Món Nhật',
    'Món Trung',
    'Món Âu',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  void addIngredient() {
    setState(() {
      ingredientControllers.add(TextEditingController());
    });
  }

  void removeIngredient(int index) {
    if (ingredientControllers.length > 1) {
      setState(() {
        ingredientControllers[index].dispose();
        ingredientControllers.removeAt(index);
      });
    }
  }

  void addStep() {
    setState(() {
      stepControllers.add(TextEditingController());
    });
  }

  void removeStep(int index) {
    if (stepControllers.length > 1) {
      setState(() {
        stepControllers[index].dispose();
        stepControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Thêm công thức mới",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                setState(() {
                  isUploading = true;
                });

                // Simulate upload delay
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    isUploading = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Công thức đã được thêm thành công'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.pop(context);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng nhập đầy đủ thông tin'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: isUploading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.orange,
                    ),
                  )
                : const Icon(Icons.check, color: Colors.orange),
            label: Text(
              isUploading ? "Đang lưu..." : "Lưu",
              style: const TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
      body: isUploading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.orange),
                  SizedBox(height: 16),
                  Text("Đang lưu công thức của bạn..."),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image upload section
                  GestureDetector(
                    onTap: () {
                      // Add image picker functionality
                    },
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Thêm ảnh món ăn',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Form fields
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Tên món ăn'),
                        _buildTextField(
                          controller: nameController,
                          hintText: 'Nhập tên món ăn',
                          maxLines: 1,
                        ),

                        const SizedBox(height: 20),
                        _buildSectionTitle('Thể loại món ăn'),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedCategory,
                              items: categories.map((String category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList(),
                              onChanged: (String? newCategory) {
                                setState(() {
                                  selectedCategory = newCategory!;
                                });
                              },
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.orange),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        _buildSectionTitle('Calo và Thời gian'),
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: caloController,
                                hintText: 'Calo',
                                prefixIcon: Icons.local_fire_department,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildTextField(
                                controller: timeController,
                                hintText: 'Thời gian (phút)',
                                prefixIcon: Icons.timer,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        _buildSectionTitle('Giới thiệu'),
                        _buildTextField(
                          controller: descriptionController,
                          hintText: 'Mô tả món ăn của bạn',
                          maxLines: 3,
                        ),

                        const SizedBox(height: 20),

                        // Tab layout for ingredients and steps
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              TabBar(
                                controller: _tabController,
                                indicatorColor: Colors.red,
                                indicatorWeight: 3,
                                labelColor: Colors.red,
                                unselectedLabelColor: Colors.grey,
                                labelStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                tabs: const [
                                  Tab(text: 'Nguyên liệu'),
                                  Tab(text: 'Các bước'),
                                ],
                              ),
                              SizedBox(
                                height: 350, // Fixed height for the tab content
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    // Ingredients tab
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount:
                                                  ingredientControllers.length,
                                              itemBuilder: (context, index) {
                                                return _buildIngredientItem(
                                                    index);
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton.icon(
                                            onPressed: addIngredient,
                                            icon: const Icon(Icons.add),
                                            label:
                                                const Text('Thêm nguyên liệu'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              minimumSize: const Size(
                                                  double.infinity, 45),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Steps tab
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: stepControllers.length,
                                              itemBuilder: (context, index) {
                                                return _buildStepItem(index);
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton.icon(
                                            onPressed: addStep,
                                            icon: const Icon(Icons.add),
                                            label: const Text('Thêm bước'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              minimumSize: const Size(
                                                  double.infinity, 45),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                descriptionController.text.isNotEmpty) {
                              setState(() {
                                isUploading = true;
                              });

                              // Simulate upload delay
                              Future.delayed(const Duration(seconds: 2), () {
                                setState(() {
                                  isUploading = false;
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Công thức đã được thêm thành công'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                Navigator.pop(context);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Vui lòng nhập đầy đủ thông tin'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kprimaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Đăng công thức',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    IconData? prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? helperText,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
        helperMaxLines: 3,
        helperStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
        ),
        fillColor: Colors.white,
        filled: true,
        contentPadding: const EdgeInsets.all(12),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: Colors.grey) : null,
      ),
    );
  }

  Widget _buildIngredientItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: ingredientControllers[index],
              decoration: InputDecoration(
                hintText: 'Nguyên liệu ${index + 1}',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => removeIngredient(index),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: stepControllers[index],
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Mô tả bước ${index + 1}',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: () => removeStep(index),
          ),
        ],
      ),
    );
  }
}
