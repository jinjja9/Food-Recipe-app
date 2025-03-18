import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/color.dart';
import '../../models/category.dart';
import '../../models/food.dart';
import 'rating_dialog.dart';

class RecipeScreen extends StatefulWidget {
  final Food food;
  const RecipeScreen({super.key, required this.food});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  int currentNumber = 1;
  String currentCat = 'Món Âu';

  List<String> get categoriesToShow {
    return catgories.where((category) => category != "Tất cả").toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const RatingDialog(); // Hiển thị dialog
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kprimaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Đánh giá"),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.width - 20,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.food.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fixedSize: const Size(50, 50),
                        ),
                        icon: const Icon(CupertinoIcons.chevron_back),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fixedSize: const Size(50, 50),
                        ),
                        icon: const Icon(Icons.delete),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {},
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fixedSize: const Size(50, 50),
                        ),
                        icon: const Icon(Icons.favorite),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.width - 40,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: AssetImage('assets/images/avatar1.png'),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3), // Màu bóng
                          blurRadius: 5, // Độ mờ bóng
                          spreadRadius: 1, // Độ lan tỏa bóng
                          offset: const Offset(0, 3), // Vị trí bóng
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đóng góp bởi',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Miss Meri',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[400]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.flash_on_rounded,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "${widget.food.cal} Calo",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const Text(
                        " · ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Icon(
                        Icons.timelapse,
                        size: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "${widget.food.time} phút",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow.shade700,
                        size: 25,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.food.rate}/5",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "(${widget.food.reviews} Người đánh giá)",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 25,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "20 lượt thích",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),

                  //Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Thể loại món ăn",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButton<String>(
                            isDense: true,
                            value: currentCat,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            dropdownColor: Colors.orange.shade300,
                            underline: Container(),
                            icon: const Icon(Icons.arrow_drop_down,
                                color: Colors.white),
                            onChanged: (String? newCategory) {
                              setState(() {
                                currentCat = newCategory ?? currentCat;
                              });
                            },
                            items: categoriesToShow
                                .map<DropdownMenuItem<String>>(
                                    (String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),

                  const Text(
                    'Giới thiệu',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Hamburger là một món ăn phổ biến trên toàn thế giới, đặc biệt tại các nước phương Tây. Đây là một loại bánh sandwich gồm một miếng thịt kẹp giữa hai lát bánh mì tròn, thường được ăn kèm với rau xanh, phô mai, sốt và các loại gia vị khác.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  const Text(
                    'Thành phần',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '''
Bánh mì hamburger: Thường có hình tròn, mềm, đôi khi được rắc mè.
Thịt xay: Phổ biến nhất là thịt bò, nhưng cũng có thể dùng gà, heo hoặc cá.
Phô mai (tùy chọn): Phổ biến nhất là cheddar hoặc mozzarella.
Rau củ: Xà lách, cà chua, dưa leo, hành tây, dưa chua.
Sốt: Mayonnaise, sốt cà chua, mù tạt, sốt BBQ hoặc sốt đặc biệt của từng thương hiệu.
''',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.grey,
                    thickness: 0.5,
                  ),
                  const Text(
                    'Hướng dẫn',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '''
Bước 1: Chuẩn Bị Nguyên Liệu
• Thái lát cà chua, dưa leo, hành tây và xà lách.
• Nướng hoặc làm nóng bánh mì để tăng độ giòn.

Bước 2: Chế Biến Thịt
• Trộn thịt bò xay với muối, tiêu, và một ít bột tỏi (tùy chọn).
• Nặn thành miếng tròn dày khoảng 1,5 cm.
• Nướng trên bếp hoặc áp chảo với lửa vừa trong 3-4 phút mỗi mặt.
• Đặt phô mai lên thịt khi gần chín để phô mai tan chảy.

Bước 3: Lắp Ráp Hamburger
• Phết sốt lên bánh mì.
• Đặt rau xanh, thịt, phô mai, và các nguyên liệu khác theo sở thích.
• Đậy nắp bánh lên và ấn nhẹ để kết dính.

Bước 4: Thưởng Thức
• Dùng kèm khoai tây chiên hoặc salad để tăng thêm hương vị.
• Có thể kết hợp với nước ngọt hoặc bia để tận hưởng trọn vẹn hương vị của món ăn.
''',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
