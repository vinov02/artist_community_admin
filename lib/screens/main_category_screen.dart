import 'package:flutter/material.dart';

class MainCategoryScreen extends StatelessWidget {
  static const String id = 'maincategory';
  const MainCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: const Text(
        'Main Category',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 36,
        ),
      ),
    );
  }
}
