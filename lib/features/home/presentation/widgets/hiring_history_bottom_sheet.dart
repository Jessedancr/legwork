import 'package:flutter/material.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_button.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';

// TEXTFORMFIELD KEY
final formKey = GlobalKey<FormState>();

class HiringHistoryBottomSheet extends StatefulWidget {
  final void Function()? onPressed;
  final dynamic Function()? showDatePicker;
  final TextEditingController jobTitleController;
  final TextEditingController locationController;
  final TextEditingController dateController;
  final TextEditingController numOfDancersController;
  final TextEditingController paymentController;
  final TextEditingController jobDescrController;

  const HiringHistoryBottomSheet({
    super.key,
    required this.dateController,
    required this.jobDescrController,
    required this.jobTitleController,
    required this.locationController,
    required this.numOfDancersController,
    required this.paymentController,
    required this.onPressed,
    required this.showDatePicker,
  });

  @override
  State<HiringHistoryBottomSheet> createState() =>
      _HiringHistoryBottomSheetState();
}

class _HiringHistoryBottomSheetState extends State<HiringHistoryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // RETURNED WIDGET
    return SingleChildScrollView(
      child: Container(
        height: screenHeight * 1.25,
        decoration: BoxDecoration(
          //color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Job Title text field
                AuthTextFormField(
                  hintText: 'Title/Type of Job',
                  obscureText: false,
                  controller: widget.jobTitleController,
                  icon: Image.asset('images/icons/title.png'),
                  helperText: 'Ex: TV commercial',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill in the type of job you offered';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Location textfield
                AuthTextFormField(
                  hintText: 'Location',
                  obscureText: false,
                  controller: widget.locationController,
                  icon: Image.asset(
                    'images/icons/location.png',
                    //height: 2,
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
                  hintText: 'date',
                  obscureText: false,
                  controller: widget.dateController,
                  icon: const Icon(Icons.date_range),
                  onTap: widget.showDatePicker,
                ),
                const SizedBox(height: 20),

                // Number of dancers hired
                AuthTextFormField(
                  keyboardType: TextInputType.number,
                  hintText: 'Number of dancers hired',
                  obscureText: false,
                  controller: widget.numOfDancersController,
                  icon: Image.asset('images/icons/employer.png'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill in the number of dancers you employed or worked with';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Payment offered
                AuthTextFormField(
                  helperText: 'Ex: 50000',
                  keyboardType: TextInputType.number,
                  hintText: 'payment offered on job',
                  obscureText: false,
                  controller: widget.paymentController,
                  icon: Icon(Icons.money),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'How much did you pay the dancers you worked with?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Job Description
                LargeTextField(
                  hintText: 'Job description',
                  obscureText: false,
                  controller: widget.jobDescrController,
                  icon: const Icon(Icons.description),
                ),

                // Save button
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
