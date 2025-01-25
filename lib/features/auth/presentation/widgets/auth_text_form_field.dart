import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthTextFormField extends StatelessWidget {
  BorderRadius borderRadius = BorderRadius.circular(30);
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? helperText;
  final Widget icon;
  final double? width;
  final String? Function(String?)? validator;
  final Function()? onTap;
  TextInputType? keyboardType;
  AuthTextFormField(
      {super.key,
      required this.hintText,
      required this.obscureText,
      required this.controller,
      this.helperText,
      required this.icon,
      this.width,
      this.validator,
      this.keyboardType,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Textfield
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
          ),
          child: SizedBox(
            width: width,
            child: TextFormField(
              onTap: onTap,
              keyboardType: keyboardType,
              validator: validator,
              controller: controller,
              obscureText: obscureText,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
                helper: Text(
                  helperText ?? '',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: borderRadius,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: borderRadius,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  borderRadius: borderRadius,
                ),
              ),
            ),
          ),
        ),

        // Custom leading icon

        Positioned(
          top: -0.9,
          left: 20,
          bottom: 25,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: screenWidth * 0.12,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: icon,
            ),
          ),
        )
      ],
    );
  }
}
