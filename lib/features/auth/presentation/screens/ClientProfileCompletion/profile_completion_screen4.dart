import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/Features/auth/presentation/Widgets/hiring_history_tile.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/Features/home/presentation/widgets/hiring_history_bottom_sheet.dart';

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

    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // METHOD THAT SHOWS BOTTOM SHEET TO ADD WORK EXPERIENCE
    void addWorkExperience() {
      showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
                    child: BlurEffect(
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Text(
                                'Got it! Now add a title to your resume',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.robotoSlab(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: Text(
                                  'Describe your expertise in your own words',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoSlab(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
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
                  width: screenWidth,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        // Professional title Text field
                        AuthTextFormField(
                          hintText: 'Professional title',
                          helperText:
                              'Ex: Professional dancer and choreographer',
                          obscureText: false,
                          controller: widget.professonalTitleController,
                          icon: Image.asset('images/icons/title.png'),
                        ),
                        SizedBox(height: screenHeight * 0.01),

                        // WORK EXPERIENCE BUTTON
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: LegworkElevatedButton(
                            onPressed: addWorkExperience,
                            buttonText: 'work experience',
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            maximumSize: WidgetStatePropertyAll(Size(
                              screenWidth * 0.55,
                              screenHeight,
                            )),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),

                        // ADD WORK EXPERIENCE HERE
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.37,
                                width: screenWidth,
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
