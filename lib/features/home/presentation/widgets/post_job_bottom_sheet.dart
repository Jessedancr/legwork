import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_search_bar.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_tile.dart';
import 'package:legwork/Features/auth/presentation/Widgets/large_textfield.dart';
import 'package:legwork/Features/auth/presentation/widgets/auth_button.dart';
import 'package:legwork/core/Constants/jobs_list.dart';

// TEXTFORMFIELD KEY
final formKey = GlobalKey<FormState>();
// Track selected skills
final List selectedSkills = [];

class PostJobBottomSheet extends StatefulWidget {
  final void Function()? onPressed;
  final TextEditingController titleController;
  final TextEditingController locationController;
  final TextEditingController danceStylesController;
  final TextEditingController payController;
  final TextEditingController jobDurationController;
  final TextEditingController amtOfDancersController;
  final TextEditingController jobDescrController;
  final SearchController searchController;
  const PostJobBottomSheet({
    super.key,
    required this.onPressed,
    required this.titleController,
    required this.locationController,
    required this.danceStylesController,
    required this.payController,
    required this.jobDurationController,
    required this.amtOfDancersController,
    required this.jobDescrController,
    required this.searchController
  });

  @override
  State<PostJobBottomSheet> createState() => _PostJobBottomSheetState();
}

class _PostJobBottomSheetState extends State<PostJobBottomSheet> {
  void checkBoxTapped(bool value, int index) {
    debugPrint('$index, $value');
    setState(() {
      jobs[index][1] = value;
      if (value) {
        // Add the skill to the selected skills list
        selectedSkills.add(jobs[index][0]);
      } else {
        // Remove the skill from the selected skills list
        selectedSkills.remove(jobs[index][0]);
      }
    });
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {    
    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // JOB TYPE SEARCH FIELD
                  JobSearchBar(
                    searchController: widget.searchController,
                    suggestionsBuilder: (context, controller) {
                      // Filter jobs based on the search query
                      final filteredJobs = jobs.where(
                        (job) {
                          // Return empty search controller or the search query converted to lower case
                          return controller.text.isEmpty ||
                              job[0]
                                  .toLowerCase()
                                  .contains(controller.text.toLowerCase());
                        },
                      ).toList();
                      return [
                        SizedBox(
                          height: 500,
                          child: ListView.builder(
                            itemCount: filteredJobs.length,
                            itemBuilder: (context, index) {
                              final jobIndex =
                                  jobs.indexOf(filteredJobs[index]);
                              return JobTile(
                                job: filteredJobs[index][0],
                                checkedValue: filteredJobs[index][1],
                                onChanged: (value) => checkBoxTapped(
                                  value!,
                                  jobIndex,
                                ),
                              );
                            },
                          ),
                        ),
                      ];
                    },
                  ),
                  const SizedBox(height: 50),

                  // JOB TITLE TEXT FIELD
                  AuthTextFormField(
                    hintText: 'Title of job',
                    obscureText: false,
                    controller: widget.titleController,
                    icon: Image.asset('images/icons/title.png'),
                    helperText: 'Ex: Dancers for TV commercial',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill in your job role/title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // LOCATION TEXTFIELD
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
                        return 'Please fill in location abi the work wey you wan do no get location?';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // AuthTextFormField(
                  //   hintText: 'date',
                  //   obscureText: false,
                  //   controller: widget.dateController,
                  //   icon: const Icon(Icons.date_range),
                  //   onTap: widget.showDatePicker,
                  // ),
                  // const SizedBox(height: 20),

                  // DANCE STYLES TEXT FIELD
                  AuthTextFormField(
                    hintText: 'dance styles needed',
                    obscureText: false,
                    controller: widget.danceStylesController,
                    icon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 20),

                  // AMT OF DANCERS NEEDED
                  AuthTextFormField(
                    helperText: "How many dancers do you need for this job?",
                    hintText: 'Amount of dancers needed',
                    obscureText: false,
                    controller: widget.amtOfDancersController,
                    icon: const Icon(Icons.numbers),
                  ),
                  const SizedBox(height: 20),

                  // REMUNERATION
                  AuthTextFormField(
                    keyboardType: TextInputType.number,
                    helperText: "How much are you going to pay the dancers?",
                    hintText: 'Dancers pay/remuneration',
                    obscureText: false,
                    controller: widget.payController,
                    icon: const Icon(Icons.attach_money),
                  ),
                  const SizedBox(height: 20),

                  // JOB DURATION TEXT FIELD
                  AuthTextFormField(
                    hintText: 'Job duration',
                    helperText: 'How long is the job going to last',
                    obscureText: false,
                    controller: widget.jobDurationController,
                    icon: const Icon(Icons.timer_outlined),
                  ),
                  const SizedBox(height: 20),

                  LargeTextField(
                    hintText: 'Job description',
                    obscureText: false,
                    controller: widget.jobDescrController,
                    icon: const Icon(Icons.description),
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
      ),
    );
  }
}
