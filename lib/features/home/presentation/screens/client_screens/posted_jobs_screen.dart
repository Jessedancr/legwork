import 'package:flutter/material.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_button.dart';

class PostedJobsScreen extends StatefulWidget {
  const PostedJobsScreen({super.key});

  @override
  State<PostedJobsScreen> createState() => _PostedJobsScreenState();
}

class _PostedJobsScreenState extends State<PostedJobsScreen> {
  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('POSTED JOBS SCREEN'),
            const SizedBox(height: 25),

            // Button
            AuthButton(
              onPressed: () {},
              buttonText: 'Post new job',
            ),
          ],
        ),
      ),
    );
  }
}
