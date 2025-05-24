import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/color.dart';
import 'edit_recipe_viewmodel.dart';
import 'widgets/ingredient_item.dart';
import 'widgets/step_item.dart';
import 'widgets/section_title.dart';
import 'widgets/custom_text_field.dart';
import '../../models/food.dart';

class EditRecipeScreen extends StatefulWidget {
  final Food food;

  const EditRecipeScreen({super.key, required this.food});

  @override
  State<EditRecipeScreen> createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EditRecipeViewModel(food: widget.food),
      child: Consumer<EditRecipeViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                "Chỉnh sửa công thức",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              centerTitle: true,
              actions: [
                TextButton.icon(
                  onPressed: () async {
                    bool ok = await vm.updateRecipe(context);
                    if (ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Công thức đã được cập nhật thành công'), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  icon: vm.isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orange),
                        )
                      : const Icon(Icons.check, color: Colors.orange),
                  label: Text(
                    vm.isUploading ? "Đang lưu..." : "Lưu",
                    style: const TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
            body: vm.isUploading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.orange),
                        SizedBox(height: 16),
                        Text("Đang cập nhật công thức của bạn..."),
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
                            vm.pickAndUploadImage();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[300],
                            child: vm.imageUrl != null
                                ? Image.network(
                                    vm.imageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text('Thay đổi ảnh món ăn', style: TextStyle(color: Colors.grey, fontSize: 16)),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SectionTitle(title: 'Tên món ăn'),
                              CustomTextField(
                                controller: vm.nameController,
                                hintText: 'Nhập tên món ăn',
                                maxLines: 1,
                              ),
                              const SizedBox(height: 20),
                              const SectionTitle(title: 'Thể loại món ăn'),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: vm.selectedCategory,
                                    items: vm.categories.map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Text(category),
                                      );
                                    }).toList(),
                                    onChanged: vm.setCategory,
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.orange),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const SectionTitle(title: 'Calo và Thời gian'),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      controller: vm.caloController,
                                      hintText: 'Calo',
                                      prefixIcon: Icons.local_fire_department,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomTextField(
                                      controller: vm.timeController,
                                      hintText: 'Thời gian (phút)',
                                      prefixIcon: Icons.timer,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              const SectionTitle(title: 'Giới thiệu'),
                              CustomTextField(
                                controller: vm.descriptionController,
                                hintText: 'Mô tả món ăn của bạn',
                                maxLines: 3,
                              ),
                              const SizedBox(height: 20),
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
                                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      tabs: const [
                                        Tab(text: 'Nguyên liệu'),
                                        Tab(text: 'Các bước'),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 350,
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
                                                    itemCount: vm.ingredientControllers.length,
                                                    itemBuilder: (context, index) {
                                                      return IngredientItem(
                                                        controller: vm.ingredientControllers[index],
                                                        index: index,
                                                        onRemove: () => vm.removeIngredient(index),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                ElevatedButton.icon(
                                                  onPressed: vm.addIngredient,
                                                  icon: const Icon(Icons.add),
                                                  label: const Text('Thêm nguyên liệu'),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                    minimumSize: const Size(double.infinity, 45),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
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
                                                    itemCount: vm.stepControllers.length,
                                                    itemBuilder: (context, index) {
                                                      return StepItem(
                                                        controller: vm.stepControllers[index],
                                                        index: index,
                                                        onRemove: () => vm.removeStep(index),
                                                      );
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                ElevatedButton.icon(
                                                  onPressed: vm.addStep,
                                                  icon: const Icon(Icons.add),
                                                  label: const Text('Thêm bước'),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                    minimumSize: const Size(double.infinity, 45),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
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
                                onPressed: () async {
                                  bool ok = await vm.updateRecipe(context);
                                  if (ok) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Công thức đã được cập nhật thành công'), backgroundColor: Colors.green),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin'), backgroundColor: Colors.red),
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
                                  'Cập nhật công thức',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        },
      ),
    );
  }
} 