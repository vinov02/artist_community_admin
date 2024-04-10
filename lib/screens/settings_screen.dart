import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const String id = 'settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(10),
      child: const Text(
        'Settings ',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 36,
        ),
      ),
    );
  }
}
