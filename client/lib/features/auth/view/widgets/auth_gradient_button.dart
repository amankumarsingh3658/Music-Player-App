import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  const AuthGradientButton({super.key, required this.buttonText , required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          gradient: const LinearGradient(
            colors: [Pallete.gradient1, Pallete.gradient2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: const Size(395, 55),
              backgroundColor: Pallete.transparentColor,
              shadowColor: Pallete.transparentColor),
          onPressed: onTap,
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          )),
    );
  }
}
