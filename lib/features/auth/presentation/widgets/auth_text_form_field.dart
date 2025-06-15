import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

// ignore: must_be_immutable
class AuthTextFormField extends StatelessWidget {
  BorderRadius borderRadius = BorderRadius.circular(30);

  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final String? helperText;
  final Widget icon;
  final double? width;
  final String? Function(String?)? validator;
  final Function()? onTap;
  final Widget? suffixIcon;
  TextInputType? keyboardType;
  AuthTextFormField({
    super.key,
    required this.obscureText,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.width,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.suffixIcon,
    this.helperText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Textfield
        SizedBox(
          width: width,
          child: TextFormField(
            onTap: onTap,
            keyboardType: keyboardType,
            validator: validator,
            controller: controller,
            obscureText: obscureText,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: context.colorScheme.onSurface.withOpacity(0.3),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: screenHeight(context) * 0.01,
                horizontal: screenWidth(context) * 0.09,
              ),
              fillColor: context.colorScheme.surfaceContainer,
              helper: Text(
                helperText ?? '',
                style: TextStyle(
                  color: context.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
              filled: true,
              suffixIcon: suffixIcon,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: borderRadius,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.colorScheme.secondary,
                ),
                borderRadius: borderRadius,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.colorScheme.error,
                ),
                borderRadius: borderRadius,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: context.colorScheme.error,
                  width: 2.0,
                ),
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),

        // Custom leading icon

        Positioned(
          left: -10,
          bottom: 20,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              padding: const EdgeInsets.all(8),
              color: context.colorScheme.primaryContainer,
              child: icon,
            ),
          ),
        )
      ],
    );
  }
}
