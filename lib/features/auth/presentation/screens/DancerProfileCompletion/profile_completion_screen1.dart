import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';

import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';

//TODO: IMPLEMENT UPLOADING USER'S PROFILE PICTURE TO FIREBASE STORAGE

class ProfileCompletionScreen1 extends StatefulWidget {
  final TextEditingController danceStylesController;
  final TextEditingController bioController;
  // final TextEditingController jobPaycontroller;
  final String? email;

  const ProfileCompletionScreen1({
    super.key,
    required this.email,
    required this.bioController,
    required this.danceStylesController,
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

    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            children: [
              // EXPANDED WIDGET FOR IMAGE
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/depictions/img_depc1.jpg'),
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    // TEXT CONTAINER
                    child: BlurEffect(
                      height: screenHeight * 0.18,
                      width: screenWidth * 0.8,
                      child: Column(
                        children: [
                          Text(
                            'WELCOME TO LEGWORK!',
                            style: GoogleFonts.robotoSlab(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "let's get you started by completing your profile",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Signed in as: ',
                                style: GoogleFonts.robotoSlab(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                widget.email!,
                                style: GoogleFonts.robotoSlab(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // EXPANDED WIDGET FOR THE REST OF THE SCREEN'S CONTENT
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Container(
                    height: screenHeight * 0.7,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 25,
                        ),
                        child: Column(
                          children: [
                            // PROFILE PICTURE
                            if (selectedImage == null)
                              // EMPTY PROFILE PICTURE
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Image.asset(
                                      'images/icons/user.png',
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                                  ),
                                  // Edit icon
                                  Positioned(
                                    bottom: -3,
                                    left: -3,
                                    child: GestureDetector(
                                      onTap: _pickImageFromGallery,
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        width: screenWidth * 0.1,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/svg/pen_circle.svg',
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              // PFP WITH PICTURE
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainer,
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                        image: FileImage(
                                          selectedImage!,
                                        ), // IMAGE FROM FILE
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // Edit icon
                                  Positioned(
                                    bottom: -3,
                                    left: -3,
                                    child: GestureDetector(
                                      onTap: _pickImageFromGallery,
                                      child: Container(
                                        height: screenHeight * 0.05,
                                        width: screenWidth * 0.1,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/svg/pen_circle.svg',
                                          fit: BoxFit.scaleDown,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 50),

                            // BIO TEXT FIELD
                            LargeTextField(
                              maxLength: 300,
                              labelText: 'Bio',
                              hintText: 'Bio',
                              obscureText: false,
                              controller: widget.bioController,
                              icon: SvgPicture.asset(
                                'assets/svg/pen_circle.svg',
                                fit: BoxFit.scaleDown,
                              ),
                            ),

                            // DANCE STYLES TEXT FIELD
                            AuthTextFormField(
                              helperText:
                                  'Separate each dance style with a comma',
                              labelText: 'dance styles',
                              obscureText: false,
                              controller: widget.danceStylesController,
                              icon: SvgPicture.asset(
                                'assets/svg/disco_ball.svg',
                                fit: BoxFit.scaleDown,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill in your dance styles, abi you no wan see job ni';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
