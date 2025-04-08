import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final Widget? suffixIcon;
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
      this.onTap,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final colorScheme = Theme.of(context).colorScheme;

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
              textAlign: TextAlign.left,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01,
                  horizontal: screenWidth * 0.083,
                ),
                fillColor: colorScheme.surfaceContainer,
                helper: Text(
                  helperText ?? '',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                filled: true,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.3),
                ),
                suffixIcon: suffixIcon,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 2.0,
                  ),
                  borderRadius: borderRadius,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.secondary,
                  ),
                  borderRadius: borderRadius,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.error,
                  ),
                  borderRadius: borderRadius,
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: colorScheme.error,
                    width: 2.0,
                  ),
                  borderRadius: borderRadius,
                ),
              ),
            ),
          ),
        ),

        // Custom leading icon

        Positioned(
          left: 20,
          bottom: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              padding: const EdgeInsets.all(8),
              color: colorScheme.primaryContainer,
              child: icon,
            ),
          ),
        )
      ],
    );
  }
}
