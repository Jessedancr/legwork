import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';

// TEXTFORMFIELD KEY
final formKey = GlobalKey<FormState>();

// ignore: must_be_immutable
class ProfileCompletionScreen1 extends StatefulWidget {
  final TextEditingController bioController;
  final TextEditingController danceStylePrefsController;
  final String? username;
  File? selectedImage;
  final Function(File) onImageSelected;

  ProfileCompletionScreen1({
    super.key,
    required this.bioController,
    required this.username,
    required this.danceStylePrefsController,
    required this.onImageSelected,
    this.selectedImage,
  });

  @override
  State<ProfileCompletionScreen1> createState() =>
      _ProfileCompletionScreen1State();
}

class _ProfileCompletionScreen1State extends State<ProfileCompletionScreen1> {
  _pickImageFromGallery() async {
    File image = await pickImage();
    setState(() {
      widget.selectedImage = image;
    });
    widget.onImageSelected(image);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
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
                      secondGradientColor:
                          context.colorScheme.primary.withOpacity(0.5),
                      height: screenHeight(context) * 0.18,
                      width: screenWidth(context) * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'WELCOME TO LEGWORK!',
                            style: context.text2Xl?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.surface,
                            ),
                          ),
                          Text(
                            "let's get you started by completing your profile",
                            textAlign: TextAlign.center,
                            style: context.textXl?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorScheme.surface,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Signed in as: ',
                                style: context.textLg?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: context.colorScheme.surface,
                                ),
                              ),
                              Text(
                                widget.username ?? 'username not available',
                                style: context.textLg?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.surface,
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
                      color: context.colorScheme.surface,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 25,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              // PROFILE PICTURE
                              if (widget.selectedImage == null)
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
                                        color: context.colorScheme.onSurface,
                                        height: 50,
                                      ),
                                    ),
                                    // Edit icon
                                    Positioned(
                                      bottom: -3,
                                      left: -3,
                                      child: Ink(
                                        child: InkWell(
                                          onTap: _pickImageFromGallery,
                                          child: CircleAvatar(
                                            radius: 17,
                                            backgroundColor: context
                                                .colorScheme.primaryContainer,
                                            child: SvgPicture.asset(
                                              'assets/svg/pen_circle.svg',
                                              color: context.colorScheme
                                                  .onPrimaryContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                              // * PFP with picture
                              else
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor:
                                          context.colorScheme.surfaceContainer,
                                      backgroundImage:
                                          FileImage(widget.selectedImage!),
                                    ),

                                    // Edit icon
                                    Positioned(
                                      bottom: -3,
                                      left: -3,
                                      child: GestureDetector(
                                        onTap: _pickImageFromGallery,
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: context
                                              .colorScheme.primaryContainer,
                                          child: SvgPicture.asset(
                                            'assets/svg/pen_circle.svg',
                                            color: context
                                                .colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Delete icon
                                    Positioned(
                                      bottom: -3,
                                      right: -3,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            widget.selectedImage = null;
                                          });
                                          widget.onImageSelected(File(''));
                                        },
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: context
                                              .colorScheme.primaryContainer,
                                          child: Icon(
                                            Icons.delete,
                                            color: context.colorScheme.error,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 40),

                              // * Bio textfield
                              LargeTextField(
                                labelText: 'bio',
                                maxLength: 300,
                                obscureText: false,
                                controller: widget.bioController,
                                icon: SvgPicture.asset(
                                  'assets/svg/pen_circle.svg',
                                  color: context.colorScheme.onPrimaryContainer,
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // TEXTFIELD FOR PREFERRED DANCE STYLES
                              AuthTextFormField(
                                labelText: 'preferred dance styles',
                                obscureText: false,
                                controller: widget.danceStylePrefsController,
                                icon: SvgPicture.asset(
                                  'assets/svg/disco_ball.svg',
                                  color: context.colorScheme.onPrimaryContainer,
                                  fit: BoxFit.scaleDown,
                                ),
                                helperText: 'Ex: Afro, Hiphop',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'please input your preferred dance styles';
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
