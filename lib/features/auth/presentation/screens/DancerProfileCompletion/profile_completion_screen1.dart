import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // WELCOME MESAAGE
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'WELCOME TO LEGWORK!',
                      style: GoogleFonts.robotoSlab(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      "let's get you started by completing your profile",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoSlab(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Signed in as: ',
                          style: GoogleFonts.robotoSlab(),
                        ),
                        Text(
                          widget.email!,
                          style: GoogleFonts.robotoSlab(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 50),

              // CONTAINER FOR PROFILE PICTURE
              if (selectedImage == null)
                Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(Icons.person),
                    ),
                    // Edit icon
                    Positioned(
                      bottom: 5,
                      child: Ink(
                        child: InkWell(
                          onTap: _pickImageFromGallery,
                          child: Image.asset(
                            'images/icons/edit-tools.png',
                            height: screenHeight * 0.035,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                Container(
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
              const SizedBox(height: 50),

              // TEXT FIELD FOR BIO
              LargeTextField(
                hintText: 'Enter your bio',
                obscureText: false,
                controller: widget.bioController,
                icon: Image.asset(
                  'images/icons/edit-tools.png',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              // TEST TEXT AREA
            ],
          ),
        ),
      ),
    );
  }
}
