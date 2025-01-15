import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:legwork/Features/auth/presentation/Widgets/large_textfield.dart';

// TODO: PROPERLY FILL OUT THIS UI
//TODO: IMPLEMENT UPLOADING USER'S PROFILE PICTURE TO FIREBASE STORAGE

class ProfileCompletionScreen1 extends StatefulWidget {
  final TextEditingController bioController;
  final String? email;

  const ProfileCompletionScreen1({
    super.key,
    required this.email,
    required this.bioController,
  });

  @override
  State<ProfileCompletionScreen1> createState() =>
      _ProfileCompletionScreen1State();
}

class _ProfileCompletionScreen1State extends State<ProfileCompletionScreen1> {
  // Instance of firebase auth
  final auth = FirebaseAuth.instance;

  // Seleced image
  File? selectedImage;

  // This function picks an image from the gallery
  Future _pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;

    setState(() {
      selectedImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    // RETURNED SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          children: [
            // WELCOME MESAAGE
            const Text('WELCOME TO LEGWORK!. Let\'s get your profile set up'),
            const SizedBox(height: 10),
            Text('Signed in as: ${widget.email!}'),
            const SizedBox(height: 30),

            // CONTAINER FOR PROFILE PICTURE
            selectedImage == null

                // EMPTY IMAGE CONTAINER
                ? Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(Icons.person),
                  )

                // IMAGE CONTAINER
                : Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: FileImage(selectedImage!), // IMAGE FROM FILE
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(height: 20),

            // ADD PROFILE PICTURE BUTTON
            TextButton(
              onPressed: _pickImageFromGallery,
              child: const Text('Add Profile Picture'),
            ),

            // TEXT FIELD FOR BIO
            LargeTextField(
              hintText: 'Enter your bio',
              obscureText: false,
              controller: widget.bioController,
              icon: Icons.pending_actions,
            ),
          ],
        ),
      ),
    );
  }
}
