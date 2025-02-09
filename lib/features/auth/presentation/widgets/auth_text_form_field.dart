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
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
                helper: Text(
                  helperText ?? '',
                  style: GoogleFonts.robotoCondensed(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                filled: true,
                hintText: hintText,
                hintStyle: GoogleFonts.robotoSlab(
                  color: Colors.grey,
                ),
                suffixIcon: suffixIcon,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                  borderRadius: borderRadius,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: borderRadius,
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  borderRadius: borderRadius,
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 2.0,
                    ),
                    borderRadius: borderRadius),
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
