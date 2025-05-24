import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/entities.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_search_bar.dart';

import 'package:legwork/core/Constants/jobs_list.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_checkbox_tile.dart';

// Track selected skills
final List selectedJobTypes = [];

class ProfileCompletionScreen2 extends StatefulWidget {
  const ProfileCompletionScreen2({super.key});

  @override
  State<ProfileCompletionScreen2> createState() =>
      _ProfileCompletionScreen2State();
}

class _ProfileCompletionScreen2State extends State<ProfileCompletionScreen2> {
  // CONTROLLERS
  final TextEditingController skillTypeController = TextEditingController();
  final SearchController searchController = SearchController();

  // * Local list of job objects where each job has a name and isSelected prop
  List<Job> jobTypes = [];

  // * Here, we take the global job lists and convert each one to a Job object using .map()
  @override
  void initState() {
    jobTypes =
        jobsList.map((job) => Job(name: job[0], isSelected: job[1])).toList();
    super.initState();
  }

  // METHOD TO CHECK AND UNCHECK THE CHECKBOX
  void checkBoxTapped(bool value, int index) {
    debugPrint('$index, $value');
    setState(() {
      jobTypes[index].isSelected = value;
      if (value && !selectedJobTypes.contains(jobTypes[index].name)) {
        selectedJobTypes.add(jobTypes[index].name);
      } else {
        selectedJobTypes.remove(jobTypes[index].name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
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
                    child: BlurEffect(
                      height: screenHeight(context) * 0.18,
                      width: screenWidth(context) * 0.8,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'What type of jobs are you offering?',
                              textAlign: TextAlign.end,
                              style: context.text2Xl?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                            Text(
                              'Search for jobs you would be posting',
                              style: context.textXl?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: context.colorScheme.onPrimary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // EXPANDED WIDGET FOR OTHER SCREEN CONTENTS
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 15.0,
                    ),
                    child: Column(
                      children: [
                        // Search bar
                        LegworkSearchBar(
                          barHintText: 'Search for job types',
                          searchController: searchController,
                          suggestionsBuilder: (context, controller) {
                            // Filter jobsList based on the search query.
                            // This takes a list of job names and converts them into proper job objects
                            final filteredJobs = jobTypes.where(
                              (job) {
                                // Return empty search controller or the search query converted to lower case
                                return controller.text.isEmpty ||
                                    job.name.toLowerCase().contains(
                                        controller.text.toLowerCase());
                              },
                            ).toList();

                            // Display filtered results in a single listview
                            return [
                              StatefulBuilder(
                                builder: (context, setState) {
                                  return SizedBox(
                                    height: 500,
                                    child: ListView.builder(
                                      itemCount: filteredJobs.length,
                                      itemBuilder: (context, index) {
                                        final jobIndex = jobTypes.indexWhere(
                                            (job) =>
                                                job.name ==
                                                filteredJobs[index].name);
                                        return LegworkCheckboxTile(
                                          title: filteredJobs[index].name,
                                          checkedValue:
                                              filteredJobs[index].isSelected,
                                          onChanged: (value) {
                                            checkBoxTapped(value!, jobIndex);
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

                        // SHOW SELECTED SKILLS
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Selected Jobs:',
                                style: context.textXl?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Show selected skills
                              Expanded(
                                child: ListView.builder(
                                  itemCount: selectedJobTypes.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: context.colorScheme.onSurface,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        '- ${selectedJobTypes[index]}',
                                        style: context.textLg?.copyWith(
                                          color: context.colorScheme.surface,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
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
