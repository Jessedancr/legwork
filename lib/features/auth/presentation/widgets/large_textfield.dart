import 'package:flutter/material.dart';

//TODO: PROPERLY STYLE THIS TEXTFIELD ONCE DONE INTEGRATING WITH FIREBASE

class LargeTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? helperText;
  final Widget icon;
  final double? width;

  const LargeTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    this.helperText,
    required this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED WIDGET
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Textfield
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.1,
            right: screenWidth * 0.1,
          ),
          child: SizedBox(
            width: width,
            child: TextField(
              //keyboardType: TextInputType.emailAddress,
              maxLines: 4,
              maxLength: 150,
              controller: controller,
              obscureText: obscureText,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: screenWidth * 0.08,
                  top: screenHeight * 0.03,
                  right: screenWidth * 0.08,
                ),
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
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ),

        // Custom leading icon

        Positioned(
          //top: -0.5,
          left: screenWidth * 0.06,
          height: 30,
          width: 41,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: icon,
            ),
          ),
        )
      ],
    );
  }
}
