import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_button.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_textfield.dart';
import 'package:legwork/Features/auth/presentation/Widgets/large_textfield.dart';

class WorkExperienceBottomSheet extends StatefulWidget {
  const WorkExperienceBottomSheet({super.key});

  @override
  State<WorkExperienceBottomSheet> createState() =>
      _WorkExperienceBottomSheetState();
}

class _WorkExperienceBottomSheetState extends State<WorkExperienceBottomSheet> {
  @override
  Widget build(BuildContext context) {
    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // CONTROLLERS
    final TextEditingController titleController = TextEditingController();
    final TextEditingController employerController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController jobDescrController = TextEditingController();

    // RETURNED WIDGET
    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          //color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10,
          ),
          child: Column(
            children: [
              // Job Title text field
              AuthTextFormField(
                hintText: 'Title',
                obscureText: false,
                controller: titleController,
                icon: Image.asset('images/icons/title.png'),
                helperText: 'Ex: back up dancer',
              ),
              const SizedBox(height: 20),

              // Employer text field
              AuthTextFormField(
                hintText: 'Employer',
                obscureText: false,
                controller: employerController,
                icon: Image.asset('images/icons/employer.png'),
                helperText: 'Ex: TMG',
              ),
              const SizedBox(height: 20),

              // Location textfield
              AuthTextFormField(
                hintText: 'Location',
                obscureText: false,
                controller: locationController,
                icon: Image.asset(
                  'images/icons/location.png',
                  //height: 2,
                ),
                helperText: 'Ex: Lekki phase 1',
              ),
              const SizedBox(height: 20),

              // TODO: Implement date picker here

              LargeTextField(
                hintText: 'Job description',
                obscureText: false,
                controller: jobDescrController,
                icon: Icon(
                  Icons.description,
                ),
              ),

              AuthButton(
                onPressed: () {},
                buttonText: 'Save',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
