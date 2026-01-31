import 'package:flutter/widgets.dart';

class Category {
  final String name;
  final String image;
  final IconData? icon;

  Category({
    required this.name,
    required this.image,
    this.icon,
  });
}
