import 'package:flutter/material.dart';

class CustomFormWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  const CustomFormWidget(
      {Key? key,
      required this.labelText,
      required this.hintText,
      required this.icon,
      required this.isPassword,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.focusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        fillColor: Colors.white, // Adjust the color here
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey, width: 0.0),
        ),
        border: const OutlineInputBorder(),
        labelText: labelText,
        hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            color: Colors.grey),
        labelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            fontFamily: 'OpenSans'),
        prefixIcon: Icon(icon, color: Colors.black54),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
    );
  }
}
