import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_snackbar_content.dart';

class JobsForYou extends StatefulWidget {
  const JobsForYou({super.key});

  @override
  State<JobsForYou> createState() => _JobsForYouState();
}

class _JobsForYouState extends State<JobsForYou> {
  void showSnackBar() {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        content: LegWorkSnackBarContent(
          screenHeight: screenHeight,
          context: context,
          screenWidth: screenWidth,
          title: 'Oh Snap!',
          subTitle: "This is supposed to be an error snackbar",
          contentColor: Theme.of(context).colorScheme.error,
          imageColor: Theme.of(context).colorScheme.onError,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Dancer for you page'),
          ElevatedButton(
            onPressed: showSnackBar,
            child: const Text('Press me'),
          )
        ],
      ),
    );
  }
}
