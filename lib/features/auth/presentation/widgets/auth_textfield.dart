import 'package:flutter/material.dart';

//TODO: PROPERLY STYLE THIS TEXTFIELD ONCE DONE INTEGRATING WITH FIREBASE

class AuthTextfield extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final String? helperText;
  final Widget icon;
  final double? width;

  const AuthTextfield({
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
          top: -0.7,
          left: 35,
          bottom: 25,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: screenWidth * 0.1,
              color: Theme.of(context).colorScheme.primaryContainer,
              child: icon,
            ),
          ),
        )
      ],
    );
  }
}
