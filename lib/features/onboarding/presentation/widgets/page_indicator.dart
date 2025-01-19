import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageIndicator extends StatelessWidget {
  final PageController pageController;
  final int count;
  final Color dotColor;
  //final Swa
  const PageIndicator({
    super.key,
    required this.pageController,
    required this.count,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      effect: WormEffect(
        dotColor: Theme.of(context).colorScheme.secondary,
        activeDotColor: Theme.of(context).colorScheme.primary,
        dotHeight: 10.0,
        dotWidth: 10.0,
        //type: SwapType.yRotation,
        spacing: 10.0,
      ),
      controller: pageController,
      count: count,
    );
  }
}
