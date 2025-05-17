import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showLoadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        elevation: 0.0,
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.6),
          child: Center(
            child: Lottie.asset(
              'assets/lottie/loading2.json',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      );
    },
  );
}

// Hide loading circle
void hideLoadingIndicator(BuildContext context) {
  Navigator.of(context).pop();
}
