import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';

import 'package:legwork/features/auth/presentation/Widgets/work_experience_tile.dart';
import 'package:legwork/features/home/presentation/widgets/work_experience_bottom_sheet.dart';

// WORK EXPERIENCE LIST
List workExperienceList = [];

class ProfileCompletionScreen5 extends StatefulWidget {
  final TextEditingController professonalTitleController;
  final TextEditingController titleController;
  final TextEditingController employerController;
  final TextEditingController locationController;
  final TextEditingController dateController;
  final TextEditingController jobDescrController;

  const ProfileCompletionScreen5({
    super.key,
    required this.dateController,
    required this.employerController,
    required this.jobDescrController,
    required this.locationController,
    required this.professonalTitleController,
    required this.titleController,
  });

  @override
  State<ProfileCompletionScreen5> createState() =>
      _ProfileCompletionScreen5State();
}

class _ProfileCompletionScreen5State extends State<ProfileCompletionScreen5> {
  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // METHOD TO SAVE WORK EXPERIENCE AND DISPLAY IT ON SCREEN
    void saveExperience() {
      if (formKey.currentState!.validate()) {
        setState(() {
          workExperienceList.add([
            widget.titleController.text,
            widget.employerController.text,
            widget.locationController.text,
            widget.dateController.text,
            widget.jobDescrController.text,
          ]);
        });
        debugPrint(workExperienceList.toString());
        // CLEAR THE CONTROLLERS
        widget.titleController.clear();
        widget.employerController.clear();
        widget.locationController.clear();
        widget.dateController.clear();
        widget.jobDescrController.clear();
        Navigator.of(context).pop();
      }
    }

    // DATE PICKER
    Future<void> datePicker() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        setState(() {
          widget.dateController.text = pickedDate.toString().split(' ')[0];
        });
      }
    }

    // METHOD THAT SHOWS BOTTOM SHEET TO ADD WORK EXPERIENCE
    void addWorkExperience() {
      showModalBottomSheet(
        backgroundColor: context.colorScheme.surfaceContainer,
        context: context,
        builder: (context) {
          return WorkExperienceBottomSheet(
            onPressed: saveExperience,
            employerController: widget.employerController,
            titleController: widget.titleController,
            jobDescrController: widget.jobDescrController,
            locationController: widget.locationController,
            dateController: widget.dateController,
            showDatePicker: datePicker,
          );
        },
      );
    }

    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                    child: BlurEffect(
                      height: screenHeight(context) * 0.2,
                      width: screenWidth(context) * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Got it! Now add a title to your resume',
                              textAlign: TextAlign.center,
                              style: context.text2Xl?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.surface,
                              ),
                            ),
                            Text(
                              'Describe your expertise in your own words',
                              textAlign: TextAlign.center,
                              style: context.textSm?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // EXPANDED WIDGET FOR REST OF SCREEN CONTENT
              Expanded(
                flex: 2,
                child: Container(
                  width: screenWidth(context),
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 25,
                    ),
                    child: Column(
                      children: [
                        // Professional title Text field
                        AuthTextFormField(
                          labelText: 'Professional title',
                          helperText:
                              'Ex: Professional dancer and choreographer',
                          obscureText: false,
                          controller: widget.professonalTitleController,
                          icon: SvgPicture.asset(
                            'assets/svg/brand.svg',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        SizedBox(height: screenHeight(context) * 0.01),

                        // WORK EXPERIENCE BUTTON
                        LegworkElevatedButton(
                          onPressed: addWorkExperience,
                          buttonText: 'work experience',
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          maximumSize: Size(
                            screenWidth(context) * 0.55,
                            screenHeight(context),
                          ),
                        ),
                        SizedBox(height: screenHeight(context) * 0.01),

                        // ADD WORK EXPERIENCE HERE
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight(context) * 0.37,
                                width: screenWidth(context),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: workExperienceList.length,
                                  itemBuilder: (context, index) {
                                    return WorkExperienceTile(
                                      jobTitle: workExperienceList[index][0],
                                      employer: workExperienceList[index][1],
                                      location: workExperienceList[index][2],
                                      date: workExperienceList[index][3],
                                      jobDescr: workExperienceList[index][4],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
