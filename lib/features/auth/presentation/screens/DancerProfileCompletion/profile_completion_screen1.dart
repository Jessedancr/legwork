import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';

import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';

//TODO: IMPLEMENT UPLOADING USER'S PROFILE PICTURE TO FIREBASE STORAGE

class ProfileCompletionScreen1 extends StatefulWidget {
  // CONTROLLERS
  final TextEditingController danceStylesController;
  final TextEditingController bioController;
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  child: Center(
                    // TEXT CONTAINER
                    child: BlurEffect(
                      width: screenWidth(context) * 0.8,
                      height: screenHeight(context) * 0.18,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'WELCOME TO LEGWORK!',
                            style: context.text2Xl?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                          Text(
                            "let's get you started by completing your profile",
                            textAlign: TextAlign.center,
                            style: context.textXl?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.onPrimary,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Signed in as: ',
                                style: context.textLg?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: context.colorScheme.onPrimary,
                                ),
                              ),
                              Text(
                                widget.email ?? 'email not available',
                                style: context.textLg?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.onPrimary,
                                ),
                              ),
                            ],
                          ),
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
                    height: screenHeight(context) * 0.7,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
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
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        context.colorScheme.surfaceContainer,
                                    child: SvgPicture.asset(
                                      'assets/svg/user.svg',
                                      height: 50,
                                    ),
                                  ),
                                  // Edit icon
                                  Positioned(
                                    bottom: -3,
                                    left: -3,
                                    child: GestureDetector(
                                      onTap: _pickImageFromGallery,
                                      child: CircleAvatar(
                                        radius: 17,
                                        backgroundColor: context
                                            .colorScheme.primaryContainer,
                                        child: SvgPicture.asset(
                                          'assets/svg/pen_circle.svg',
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
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor:
                                        context.colorScheme.surfaceContainer,
                                    backgroundImage: FileImage(selectedImage!),
                                  ),

                                  // Edit icon
                                  Positioned(
                                    bottom: -3,
                                    left: -3,
                                    child: GestureDetector(
                                      onTap: _pickImageFromGallery,
                                      child: CircleAvatar(
                                        radius: 17,
                                        backgroundColor: context
                                            .colorScheme.primaryContainer,
                                        child: SvgPicture.asset(
                                          'assets/svg/pen_circle.svg',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 40),

                            // BIO TEXT FIELD
                            LargeTextField(
                              maxLength: 300,
                              labelText: 'Bio',
                              obscureText: false,
                              controller: widget.bioController,
                              icon: SvgPicture.asset(
                                'assets/svg/pen_circle.svg',
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            const SizedBox(height: 8),

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
                                  return 'Please fill in your dance styles, abi you no wan see job?';
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
