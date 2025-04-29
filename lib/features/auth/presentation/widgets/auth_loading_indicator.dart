import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: Center(
          child: Lottie.asset(
            'assets/lottie/loading.json',
            width: 150,
            height: 150,
            fit: BoxFit.fill,
          ),

          // CircularProgressIndicator(
          //   color: Theme.of(context).colorScheme.primary,
          //   strokeWidth: 3.0,
          //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // ),
        ),
      );
    },
  );
}

// Hide loading circle
void hideLoadingIndicator(BuildContext context) {
  Navigator.of(context).pop();
}
