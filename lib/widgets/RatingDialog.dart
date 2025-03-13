import 'package:flutter/material.dart';

class RatingDialog extends StatefulWidget {
  const RatingDialog({super.key});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int rating = 0;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Đánh giá sản phẩm"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    rating = index + 1;
                  });
                },
              );
            }),
          ),
          //const SizedBox(height: 10),
          // TextField(
          //   controller: commentController,
          //   decoration: InputDecoration(
          //     hintText: "Nhập bình luận của bạn",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(5),
          //     ),
          //   ),
          //   maxLines: 3,
          // ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Hủy"),
        ),
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Đánh giá thành công!")),
            );
            Navigator.of(context).pop();
          },
          child: const Text("Gửi"),
        ),
      ],
    );
  }
}
