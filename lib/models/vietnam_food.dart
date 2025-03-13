import 'food.dart';

class VietNameFood extends Food {
  VietNameFood({
    required super.name,
    required super.image,
    required super.cal,
    required super.time,
    required super.rate,
    required super.reviews,
    required super.isLiked,
    required super.author,
    required super.avatarImage,
  });
}

final List<VietNameFood> foodsVietNam = [
  VietNameFood(
    name: "Nem rán",
    image: "assets/images/nem.png",
    cal: 120,
    time: 15,
    rate: 4.4,
    reviews: 23,
    isLiked: false,
    author: '',
    avatarImage: '',
  ),
  VietNameFood(
    name: "Phở",
    image: "assets/images/pho.png",
    cal: 140,
    time: 25,
    rate: 4.4,
    reviews: 23,
    isLiked: true,
    author: '',
    avatarImage: '',
  ),
  VietNameFood(
    name: "bánh cuốn",
    image: "assets/images/banh_cuon.png",
    cal: 130,
    time: 18,
    rate: 4.2,
    reviews: 10,
    isLiked: false,
    author: '',
    avatarImage: '',
  ),
];
