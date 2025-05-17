import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_button.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';

// TEXTFORMFIELD KEY
final formKey = GlobalKey<FormState>();

class WorkExperienceBottomSheet extends StatefulWidget {
  final void Function()? onPressed;
  final TextEditingController titleController;
  final TextEditingController employerController;
  final TextEditingController locationController;
  final TextEditingController jobDescrController;
  final TextEditingController dateController;
  final dynamic Function()? showDatePicker;
  const WorkExperienceBottomSheet({
    super.key,
    required this.onPressed,
    required this.employerController,
    required this.jobDescrController,
    required this.locationController,
    required this.titleController,
    required this.dateController,
    required this.showDatePicker,
  });

  @override
  State<WorkExperienceBottomSheet> createState() =>
      _WorkExperienceBottomSheetState();
}

class _WorkExperienceBottomSheetState extends State<WorkExperienceBottomSheet> {
  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;

    // RETURNED WIDGET
    return SingleChildScrollView(
      child: Container(
        height: screenHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25.0,
            vertical: 10,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Job Title text field
                AuthTextFormField(
                  labelText: 'Title',
                  obscureText: false,
                  controller: widget.titleController,
                  icon: SvgPicture.asset(
                    'assets/svg/brand.svg',
                    fit: BoxFit.scaleDown,
                  ),

                  // Image.asset('images/icons/title.png'),
                  helperText: 'Ex: back up dancer',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill in your job role/title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Employer text field
                AuthTextFormField(
                  labelText: 'Employer',
                  obscureText: false,
                  controller: widget.employerController,
                  icon: SvgPicture.asset(
                    'assets/svg/briefcase.svg',
                    fit: BoxFit.scaleDown,
                  ),
                  helperText: 'Ex: TMG',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill in your employer, abi pesin no employ you to do work??';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Location textfield
                AuthTextFormField(
                  labelText: 'Location',
                  obscureText: false,
                  controller: widget.locationController,
                  icon: SvgPicture.asset(
                    'assets/svg/location.svg',
                    fit: BoxFit.scaleDown,
                  ),
                  helperText: 'Ex: Lekki phase 1',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill in location abi the work wey you do no get location??';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Date textfield
                AuthTextFormField(
                  labelText: 'date',
                  obscureText: false,
                  controller: widget.dateController,
                  icon: SvgPicture.asset(
                    'assets/svg/calendar.svg',
                    fit: BoxFit.scaleDown,
                  ),
                  onTap: widget.showDatePicker,
                ),
                const SizedBox(height: 20),

                // Job descr text field
                LargeTextField(
                  labelText: 'Job description',
                  maxLength: 300,
                  hintText: 'Job description',
                  obscureText: false,
                  controller: widget.jobDescrController,
                  icon: SvgPicture.asset(
                    'assets/svg/info.svg',
                    fit: BoxFit.scaleDown,
                  ),
                ),

                AuthButton(
                  onPressed: widget.onPressed,
                  buttonText: 'Save',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
