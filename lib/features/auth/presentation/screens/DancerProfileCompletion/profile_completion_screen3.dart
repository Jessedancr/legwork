import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProfileCompletionScreen3 extends StatefulWidget {
  const ProfileCompletionScreen3({super.key});

  @override
  State<ProfileCompletionScreen3> createState() =>
      _ProfileCompletionScreen3State();
}

class _ProfileCompletionScreen3State extends State<ProfileCompletionScreen3> {
  // FILE PICKER METHOD
  Future<void> _uploadResume() async {
    final result = await FilePicker.platform.pickFiles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Tell us a little about yourself by uploading your resume'),
            const SizedBox(height: 25),
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: _uploadResume,
              child: const Text('Upload resume'),
            ),
          ],
        ),
      )),
    );
  }
}
