import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/hiring_history_tile.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/features/home/presentation/widgets/hiring_history_bottom_sheet.dart';

// WORK EXPERIENCE LIST
List hiringHistoryList = [];

class ProfileCompletionScreen4 extends StatefulWidget {
  final TextEditingController professonalTitleController;
  final TextEditingController jobTitleController;
  final TextEditingController locationController;
  final TextEditingController dateController;
  final TextEditingController numOfDancersController;
  final TextEditingController paymentController;
  final TextEditingController jobDescrController;
  const ProfileCompletionScreen4({
    super.key,
    required this.professonalTitleController,
    required this.dateController,
    required this.jobDescrController,
    required this.jobTitleController,
    required this.locationController,
    required this.numOfDancersController,
    required this.paymentController,
  });

  @override
  State<ProfileCompletionScreen4> createState() =>
      _ProfileCompletionScreen4State();
}

class _ProfileCompletionScreen4State extends State<ProfileCompletionScreen4> {
  @override
  Widget build(BuildContext context) {
    // METHOD TO SAVE WORK EXPERIENCE AND DISPLAY IT ON SCREEN
    void saveExperience() {
      if (formKey.currentState!.validate()) {
        setState(() {
          hiringHistoryList.add([
            widget.jobTitleController.text,
            widget.locationController.text,
            widget.dateController.text,
            widget.numOfDancersController.text,
            widget.paymentController.text,
            widget.jobDescrController.text,
          ]);
        });
        debugPrint(hiringHistoryList.toString());
        // CLEAR THE CONTROLLERS
        widget.jobTitleController.clear();
        widget.locationController.clear();
        widget.dateController.clear();
        widget.numOfDancersController.clear();
        widget.paymentController.clear();
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
        isScrollControlled: true,
        backgroundColor: context.colorScheme.surfaceContainer,
        context: context,
        builder: (context) {
          return HiringHistoryBottomSheet(
            dateController: widget.dateController,
            jobDescrController: widget.jobDescrController,
            jobTitleController: widget.jobTitleController,
            locationController: widget.locationController,
            numOfDancersController: widget.numOfDancersController,
            paymentController: widget.paymentController,
            onPressed: saveExperience,
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
                      secondGradientColor:
                          context.colorScheme.primary.withOpacity(0.5),
                      height: screenHeight(context) * 0.2,
                      width: screenWidth(context) * 0.8,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
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
                        const SizedBox(height: 10),
                        // Professional title Text field
                        AuthTextFormField(
                          labelText: 'Professional title',
                          helperText:
                              'Ex: Professional dancer and choreographer',
                          obscureText: false,
                          controller: widget.professonalTitleController,
                          icon: SvgPicture.asset(
                            'assets/svg/brand.svg',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: screenHeight(context) * 0.01),

                        // WORK EXPERIENCE BUTTON
                        LegworkElevatedButton(
                          onPressed: addWorkExperience,
                          buttonText: 'work experience',
                          icon: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onPrimary,
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
                                  itemCount: hiringHistoryList.length,
                                  itemBuilder: (context, index) {
                                    return HiringHistoryTile(
                                      jobTitle: hiringHistoryList[index][0],
                                      location: hiringHistoryList[index][1],
                                      date: hiringHistoryList[index][2],
                                      numOfDancersHired:
                                          hiringHistoryList[index][3],
                                      paymentOffered: hiringHistoryList[index]
                                          [4],
                                      jobDescr: hiringHistoryList[index][5],
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
