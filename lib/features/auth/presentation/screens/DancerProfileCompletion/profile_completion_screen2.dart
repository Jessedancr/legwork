import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/entities.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_search_bar.dart';

import 'package:legwork/core/Constants/jobs_list.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_checkbox_tile.dart';

/**
 * THIS SCREEN PROMPTS THE USER TO INPUT THE TYPE OF JOBS HE IS INTERESTED IN
 *
 */

// Track selected skills
final List selectedSkills = [];

class ProfileCompletionScreen2 extends StatefulWidget {
  const ProfileCompletionScreen2({super.key});

  @override
  State<ProfileCompletionScreen2> createState() =>
      _ProfileCompletionScreen2State();
}

class _ProfileCompletionScreen2State extends State<ProfileCompletionScreen2> {
  // final TextEditingController skillTypeController = TextEditingController();
  final SearchController searchController = SearchController();
  List<Job> jobs = [];

  @override
  void initState() {
    super.initState();
    jobs =
        jobsList.map((job) => Job(name: job[0], isSelected: job[1])).toList();
  }

  void checkBoxTapped(bool value, int index) {
    debugPrint('$index, $value');
    setState(() {
      jobs[index].isSelected = value;
      if (value) {
        selectedSkills.add(jobs[index].name);
      } else {
        selectedSkills.remove(jobs[index].name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,
        body: Center(
          child: Column(
            children: [
              // * TOP SECTION (IMAGE)
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
                              'What type of work are you looking for?',
                              textAlign: TextAlign.center,
                              style: context.text2Xl?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onPrimary,
                              ),
                            ),
                            Text(
                              'Search for skills you have',
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

              // * BOTTOM SECTION
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
                        LegworkSearchBar(
                          barHintText: 'Search skills',
                          searchController: searchController,
                          suggestionsBuilder: (context, controller) {
                            final filteredJobs = jobs.where(
                              (job) {
                                return controller.text.isEmpty ||
                                    job.name.toLowerCase().contains(
                                        controller.text.toLowerCase());
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
                                        final jobIndex = jobs.indexWhere(
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
                                            });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ];
                          },
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Selected Skills:',
                                style: context.textXl?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: selectedSkills.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: context.colorScheme.onSurface,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        '- ${selectedSkills[index]}',
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
