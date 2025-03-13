import 'package:flutter/material.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  String selectedCategory = 'Món Việt'; // Default category
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController caloController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  List<String> categories = [
    'Món Việt',
    'Món Hàn',
    'Món Nhật',
    'Món Trung',
    'Món Âu',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Màu nền trắng cho AppBar
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
            backgroundColor: Colors.white, // Màu nền trắng cho AppBar
            elevation: 0, // Bỏ shadow mặc định của AppBar
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                // Icon "back" ở góc trái với màu trắng
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black), // Đổi màu trắng cho icon back
                  onPressed: () {
                    Navigator.pop(context); // Quay lại màn hình trước
                  },
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Thêm mới", // Đổi tiêu đề app bar
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Màu chữ đen
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.check,
                    color: Colors.orange[400], // Màu cho icon
                    size: 40,
                  ),
                  onPressed: () {
                    // Logic để lưu công thức, chẳng hạn như thêm vào danh sách hoặc gửi lên server
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      // Giả sử công thức đã được lưu thành công
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Công thức đã được thêm thành công')),
                      );
                    } else {
                      // Hiển thị thông báo lỗi nếu thiếu thông tin
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vui lòng nhập đầy đủ thông tin')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tên món ăn:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Nhập tên món ăn',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Thể loại món ăn:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
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
                hint: const Text('Chọn thể loại món ăn'),
              ),
              const SizedBox(height: 20),
              // Thêm mục Calo và Thời gian
              const Text(
                'Calo và Thời gian:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Ô nhập Calo
                  Expanded(
                    child: TextField(
                      controller: caloController,
                      decoration: const InputDecoration(
                        labelText: 'Calo',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white, // Màu nền trắng
                        filled: true,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Ô nhập Thời gian
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      decoration: const InputDecoration(
                        labelText: 'Thời gian (phút)',
                        border: OutlineInputBorder(),
                        fillColor: Colors.white, // Màu nền trắng
                        filled: true,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Giới thiệu:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Mô tả món ăn',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Thành phần:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: ingredientsController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Nhập thành phần',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hướng dẫn:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: instructionsController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Nhập hướng dẫn nấu ăn',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Khung trống cho ảnh
              const Text(
                'Thêm ảnh món ăn:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'Chưa có ảnh',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Nút chọn ảnh
              ElevatedButton.icon(
                onPressed: () {
                  // Chức năng thêm ảnh sẽ được thêm sau
                },
                icon: const Icon(Icons.add_a_photo), // Icon thêm ảnh
                label: const Text('Thêm ảnh món ăn'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
