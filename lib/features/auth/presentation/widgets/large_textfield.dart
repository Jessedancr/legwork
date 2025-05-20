import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

class LargeTextField extends StatelessWidget {
  final bool obscureText;
  final TextEditingController controller;
  final String? helperText;
  final Widget icon;
  final int? maxLength;
  final Color? iconContainercolor;
  final FormFieldValidator<String>? validator;
  final String? labelText;

  const LargeTextField({
    super.key,
    required this.obscureText,
    required this.controller,
    this.helperText,
    required this.icon,
    this.maxLength,
    this.iconContainercolor,
    this.validator,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(30);

    // RETURNED WIDGET
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Textfield
        TextFormField(
          validator: validator,
          buildCounter: (
            BuildContext context, {
            required int currentLength,
            required bool isFocused,
            required int? maxLength,
          }) {
            return Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '$currentLength/$maxLength',
                style: TextStyle(
                  color: isFocused ? Colors.grey[500] : Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            );
          },
          maxLines: 4,
          maxLength: maxLength ?? 150,
          controller: controller,
          obscureText: obscureText,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: labelText,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            contentPadding: EdgeInsets.only(
              left: screenWidth(context) * 0.1,
              top: screenHeight(context) * 0.05,
              right: screenWidth(context) * 0.05,
            ),
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            helper: Text(
              helperText ?? '',
              style: TextStyle(color: Colors.grey[500]),
            ),
            filled: true,

            hintStyle: TextStyle(
              color: Colors.grey[500],
            ),

            // * Style of border when it is focused
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2.0,
              ),
              borderRadius: borderRadius,
            ),

            //* Style of border normally (when unfocused)
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: borderRadius,
            ),

            // * Style of border when on error
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
              borderRadius: borderRadius,
            ),

            // * Style of border when focused on error
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 2.0,
              ),
              borderRadius: borderRadius,
            ),
          ),
        ),

        //* Custom leading icon
        Positioned(
          left: screenWidth(context) * -0.03,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              padding: const EdgeInsets.all(8),
              color: iconContainercolor ?? context.colorScheme.primaryContainer,
              child: icon,
            ),
          ),
        )
      ],
    );
  }
}
