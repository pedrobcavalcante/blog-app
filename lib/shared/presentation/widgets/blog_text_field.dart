import 'package:flutter/material.dart';

class BlogTextField extends StatelessWidget {
  const BlogTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        prefixIcon:
            Icon(isPassword ? Icons.lock : Icons.email, color: Colors.black54),
        hintStyle: const TextStyle(color: Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.black54),
        ),
      ),
      obscureText: isPassword,
      validator: validator,
    );
  }
}
