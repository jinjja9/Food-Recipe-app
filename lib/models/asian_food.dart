import 'food.dart';

class AsianFood extends Food {
  AsianFood({
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

final List<AsianFood> foodsAsian = [
  AsianFood(
    name: "Há cảo",
    image: "assets/images/ha_cao.png",
    cal: 120,
    time: 15,
    rate: 4.4,
    reviews: 23,
    isLiked: false,
    author: '',
    avatarImage: '',
  ),
  AsianFood(
    name: "tokbokki",
    image: "assets/images/tokbokki.png",
    cal: 140,
    time: 25,
    rate: 4.4,
    reviews: 23,
    isLiked: true,
    author: '',
    avatarImage: '',
  ),
  AsianFood(
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
