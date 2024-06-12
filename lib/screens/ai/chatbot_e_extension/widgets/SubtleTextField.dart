import 'package:flutter/material.dart';

class SubtleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  SubtleTextField({required this.controller, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
