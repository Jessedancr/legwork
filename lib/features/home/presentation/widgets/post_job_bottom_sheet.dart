import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/entities.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_search_bar.dart';

import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_button.dart';
import 'package:legwork/core/Constants/jobs_list.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_checkbox_tile.dart';

// TEXTFORMFIELD KEY
final formKey = GlobalKey<FormState>();
String? selectedJobType;

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
  List<Job> jobs = [];
  void checkBoxTapped(bool value, int index) {
    debugPrint('$index, $value');
    setState(() {
      jobs[index].isSelected = value;
      if (value) {
        selectedJobType = jobs[index].name;
        debugPrint('Selected job type: $selectedJobType');
      } else {
        selectedJobType = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    jobs =
        jobsList.map((job) => Job(name: job[0], isSelected: job[1])).toList();
  }

  // BUILD METHOD
  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SingleChildScrollView(
      child: Container(
        height: screenHeight(context) * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 15,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: screenHeight(context) * 1.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      // JOB TYPE SEARCH FIELD
                      LegworkSearchBar(
                        barHintText: 'Type of job',
                        searchController: widget.searchController,
                        suggestionsBuilder: (context, controller) {
                          // Filter jobs based on the search query
                          final filteredJobs = jobs.where(
                            (job) {
                              // Return empty search controller or the search query converted to lower case
                              return controller.text.isEmpty ||
                                  job.name
                                      .toLowerCase()
                                      .contains(controller.text.toLowerCase());
                            },
                          ).toList();
                          return [
                            StatefulBuilder(
                              builder: (context, setState) {
                                return SizedBox(
                                  height: 500,
                                  child: ListView.builder(
                                    itemCount: filteredJobs.length,
                                    itemBuilder: (context, index) {
                                      final jobIndex = jobs.indexWhere((job) =>
                                          job.name == filteredJobs[index].name);
                                      return LegworkCheckboxTile(
                                        title: filteredJobs[index].name,
                                        checkedValue:
                                            filteredJobs[index].isSelected,
                                        onChanged: (value) {
                                          checkBoxTapped(
                                            value!,
                                            jobIndex,
                                          );
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
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
                            color:
                                context.colorScheme.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/briefcase.svg',
                                color: context.colorScheme.onSurface,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Selected: $selectedJobType",
                                style: context.textXs?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.onSurface,
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
                          color: context.colorScheme.onPrimaryContainer,
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
                          color: context.colorScheme.onPrimaryContainer,
                          fit: BoxFit.scaleDown,
                        ),
                        helperText: 'Ex: Lekki phase 1',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill in location';
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
                          color: context.colorScheme.onPrimaryContainer,
                          fit: BoxFit.scaleDown,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'What dance styles do you need on this job';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // AMT OF DANCERS NEEDED
                      AuthTextFormField(
                        keyboardType: TextInputType.number,
                        helperText:
                            "How many dancers do you need for this job?",
                        labelText: 'Amount of dancers needed',
                        obscureText: false,
                        controller: widget.amtOfDancersController,
                        icon: SvgPicture.asset(
                          'assets/svg/hashtag_icon.svg',
                          color: context.colorScheme.onPrimaryContainer,
                          fit: BoxFit.scaleDown,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'How many dancers do you need for this job';
                          }
                          return null;
                        },
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
                          color: context.colorScheme.onPrimaryContainer,
                          fit: BoxFit.scaleDown,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill in dancers pay';
                          }
                          return null;
                        },
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
                          color: context.colorScheme.onPrimaryContainer,
                          fit: BoxFit.scaleDown,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill in the job duration';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      LargeTextField(
                        labelText: 'Job description',
                        obscureText: false,
                        controller: widget.jobDescrController,
                        icon: SvgPicture.asset(
                          'assets/svg/description_icon.svg',
                          color: context.colorScheme.onPrimaryContainer,
                          fit: BoxFit.scaleDown,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill in job description';
                          }
                          return null;
                        },
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
      ),
    );
  }
}
