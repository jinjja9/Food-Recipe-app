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
  });
}

final List<AsianFood> foodsAsian = [
  AsianFood(
    name: "Nem rán",
    image: "assets/images/nem.png",
    cal: 120,
    time: 15,
    rate: 4.4,
    reviews: 23,
    isLiked: false,
  ),
  AsianFood(
    name: "Phở",
    image: "assets/images/pho.png",
    cal: 140,
    time: 25,
    rate: 4.4,
    reviews: 23,
    isLiked: true,
  ),
  AsianFood(
    name: "bánh cuốn",
    image: "assets/images/banh_cuon.png",
    cal: 130,
    time: 18,
    rate: 4.2,
    reviews: 10,
    isLiked: false,
  ),
];
