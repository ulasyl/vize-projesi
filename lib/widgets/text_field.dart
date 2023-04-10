import 'package:flutter/material.dart';

class InputArea extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const InputArea({
    super.key, required this.title, required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10.0),
      child: TextField(
        cursorColor: Colors.red,
        decoration: InputDecoration(
          label: Text(title),
          floatingLabelStyle: TextStyle(
            color: Colors.red
          ),
          filled: true,
          focusColor: Colors.red,
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.red)),
          fillColor: const Color.fromARGB(255, 242, 242, 242),
          border: InputBorder.none
        ),
      controller: controller,
      ),
    );
  }
}