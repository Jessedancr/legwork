import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_textfield.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_search_bar.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_tile.dart';
import 'package:legwork/core/Constants/jobs_list.dart';

// Track selected skills
final List selectedSkills = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              // Text container
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      'What type of work are you looking for?',
                      style: GoogleFonts.robotoSlab(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Search for skills you have',
                      style: GoogleFonts.robotoSlab(),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Search bar
              JobSearchBar(
                searchController: searchController,
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

                  // Display filtered results in a single listview
                  return [
                    SizedBox(
                      height: 500,
                      child: ListView.builder(
                        itemCount: filteredJobs.length,
                        itemBuilder: (context, index) {
                          final jobIndex = jobs.indexOf(filteredJobs[index]);
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
              const SizedBox(height: 40),

              // SHOW SELECTED SKILLS
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Selected Skills:',
                      style: GoogleFonts.robotoSlab(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Show selected skills
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedSkills.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              '- ${selectedSkills[index]}',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 16,
                                color: Colors.white,
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
    );
  }
}
