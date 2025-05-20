import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/job_search_bar.dart';

import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_button.dart';
import 'package:legwork/core/Constants/jobs_list.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_checkbox_tile.dart';

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
    required this.searchController,
  });

  @override
  State<PostJobBottomSheet> createState() => _PostJobBottomSheetState();
}

class _PostJobBottomSheetState extends State<PostJobBottomSheet> {
  String? selectedJobType;
  void checkBoxTapped(bool value, int index) {
    debugPrint('$index, $value');
    setState(() {
      jobsList[index][1] = value;
      if (value) {
        // Add the skill to the selected skills list
        selectedSkills.add(jobsList[index][0]);
        selectedJobType = jobsList[index][0];
      } else {
        // Remove the skill from the selected skills list
        selectedSkills.remove(jobsList[index][0]);
        selectedJobType = null;
      }
    });
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;

    // RETURNED WIDGET
    return SingleChildScrollView(
      child: Container(
        height: screenHeight * 1.5,
        decoration: BoxDecoration(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    // JOB TYPE SEARCH FIELD
                    JobSearchBar(
                      barHintText: 'Type of job',
                      searchController: widget.searchController,
                      suggestionsBuilder: (context, controller) {
                        // Filter jobs based on the search query
                        final filteredJobs = jobsList.where(
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
                                    jobsList.indexOf(filteredJobs[index]);
                                return LegworkCheckboxTile(
                                  title: filteredJobs[index][0],
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
                    const SizedBox(height: 10),

                    // Display Selected Job Type
                    if (selectedJobType != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.work,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Selected: $selectedJobType",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),

                    // JOB TITLE TEXT FIELD
                    AuthTextFormField(
                      labelText: 'Title of job',
                      obscureText: false,
                      controller: widget.titleController,
                      icon: SvgPicture.asset(
                        'assets/svg/brand.svg',
                        fit: BoxFit.scaleDown,
                      ),
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
                          return 'Please fill in location abi the work wey you wan do no get location?';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // DANCE STYLES TEXT FIELD
                    AuthTextFormField(
                      labelText: 'dance styles needed',
                      obscureText: false,
                      controller: widget.danceStylesController,
                      icon: SvgPicture.asset(
                        'assets/svg/disco_ball.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // AMT OF DANCERS NEEDED
                    AuthTextFormField(
                      helperText: "How many dancers do you need for this job?",
                      labelText: 'Amount of dancers needed',
                      obscureText: false,
                      controller: widget.amtOfDancersController,
                      icon: SvgPicture.asset(
                        'assets/svg/hashtag_icon.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // REMUNERATION
                    AuthTextFormField(
                      keyboardType: TextInputType.number,
                      labelText: 'Dancers pay/remuneration',
                      obscureText: false,
                      controller: widget.payController,
                      icon: SvgPicture.asset(
                        'assets/svg/naira_icon.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // JOB DURATION TEXT FIELD
                    AuthTextFormField(
                      labelText: 'Job duration',
                      helperText: 'How long is the job going to last',
                      obscureText: false,
                      controller: widget.jobDurationController,
                      icon: SvgPicture.asset(
                        'assets/svg/clock_icon.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(height: 20),

                    LargeTextField(
                      labelText: 'Job description',
                      obscureText: false,
                      controller: widget.jobDescrController,
                      icon: SvgPicture.asset(
                        'assets/svg/description_icon.svg',
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
        ),
      ),
    );
  }
}
