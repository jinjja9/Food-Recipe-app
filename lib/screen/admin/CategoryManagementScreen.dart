import 'package:flutter/material.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _categoryDescriptionController =
      TextEditingController();

  // Danh sách thể loại giả lập
  final List<Map<String, dynamic>> _categories = [
    {
      "id": 1,
      "name": "Món Việt",
      "description": "Các món ăn truyền thống Việt Nam",
      "recipeCount": 120,
      "color": Colors.red,
    },
    {
      "id": 2,
      "name": "Món Á",
      "description": "Các món ăn châu Á như Nhật, Hàn, Trung Quốc",
      "recipeCount": 85,
      "color": Colors.orange,
    },
    {
      "id": 3,
      "name": "Món Âu",
      "description": "Các món ăn phương Tây như Ý, Pháp, Mỹ",
      "recipeCount": 65,
      "color": Colors.blue,
    },
    {
      "id": 4,
      "name": "Món chay",
      "description": "Các món ăn chay không có thịt",
      "recipeCount": 45,
      "color": Colors.green,
    },
    {
      "id": 5,
      "name": "Đồ uống",
      "description": "Các loại đồ uống, nước giải khát",
      "recipeCount": 33,
      "color": Colors.purple,
    },
  ];

  // Danh sách màu để chọn
  final List<Color> _colorOptions = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
  ];

  Color _selectedColor = Colors.red;

  @override
  void dispose() {
    _categoryNameController.dispose();
    _categoryDescriptionController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    _categoryNameController.clear();
    _categoryDescriptionController.clear();
    _selectedColor = Colors.red;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Thêm thể loại mới"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _categoryNameController,
                    decoration: const InputDecoration(
                      labelText: "Tên thể loại",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _categoryDescriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Mô tả",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Chọn màu:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _colorOptions.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
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
                  // Thêm thể loại mới
                  if (_categoryNameController.text.isNotEmpty) {
                    setState(() {
                      _categories.add({
                        "id": _categories.length + 1,
                        "name": _categoryNameController.text,
                        "description": _categoryDescriptionController.text,
                        "recipeCount": 0,
                        "color": _selectedColor,
                      });
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Đã thêm thể loại mới"),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text("Thêm"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditCategoryDialog(int index) {
    final category = _categories[index];
    _categoryNameController.text = category["name"];
    _categoryDescriptionController.text = category["description"];
    _selectedColor = category["color"];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Chỉnh sửa thể loại"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _categoryNameController,
                    decoration: const InputDecoration(
                      labelText: "Tên thể loại",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _categoryDescriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Mô tả",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Chọn màu:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _colorOptions.map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
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
                  // Cập nhật thể loại
                  if (_categoryNameController.text.isNotEmpty) {
                    setState(() {
                      _categories[index] = {
                        "id": category["id"],
                        "name": _categoryNameController.text,
                        "description": _categoryDescriptionController.text,
                        "recipeCount": category["recipeCount"],
                        "color": _selectedColor,
                      };
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Đã cập nhật thể loại"),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Cập nhật"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(int index) {
    final category = _categories[index];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: Text(
          "Bạn có chắc chắn muốn xóa thể loại '${category["name"]}' không? "
          "Điều này sẽ ảnh hưởng đến ${category["recipeCount"]} công thức.",
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
                _categories.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Đã xóa thể loại"),
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
            title: const Text(
              "Quản lý danh mục",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Danh sách thể loại",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _showAddCategoryDialog,
                    icon: const Icon(Icons.add),
                    label: const Text("Thêm thể loại"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Container(
                          width: 12,
                          height: double.infinity,
                          color: category["color"],
                        ),
                        title: Text(
                          category["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(category["description"]),
                            const SizedBox(height: 4),
                            Text(
                              "${category["recipeCount"]} công thức",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditCategoryDialog(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmation(index),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
