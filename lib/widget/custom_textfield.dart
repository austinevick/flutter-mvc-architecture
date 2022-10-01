import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  const CustomTextField({super.key, this.controller});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: TextField(
            controller: widget.controller,
            cursorColor: Colors.black,
            cursorWidth: 1,
            onChanged: (val) {},
            autofocus: true,
            style: const TextStyle(
                fontSize: 16, color: Colors.black, fontWeight: FontWeight.w800),
            decoration: const InputDecoration(
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Search movies here'),
          ),
        ));
  }
}
