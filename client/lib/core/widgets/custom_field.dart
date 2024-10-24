import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final bool isObsecure;
  final TextEditingController? controller;
  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.isObsecure = false,
      this.onTap,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
      obscureText: isObsecure,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
