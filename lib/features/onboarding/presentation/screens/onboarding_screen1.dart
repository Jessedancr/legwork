import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/glass_box.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Screen size
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED SCAFFOLD
    return Scaffold(
      // Image
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
            image: AssetImage(
              'images/OnboardingImages/onboarding_image1.jpg',
            ),
          ),
        ),

        // Glass Box
        child: Container(
          alignment: const Alignment(0, 1),
          child: GlassBox(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome To Legwork!',
                    style: GoogleFonts.robotoSlab(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // SOME OTHER TEXT
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      'Empowering Nigerian dancers: Join the platform that puts your talents to work',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoCondensed(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
