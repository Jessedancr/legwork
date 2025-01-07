import 'package:flutter/material.dart';

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const AlertDialog(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        content: Center(
          child: CircularProgressIndicator(),
        ),
      );
    },
  );
}

// Hide loading circle
void hideLoadingIndicator(BuildContext context) {
  Navigator.of(context).pop();
}
