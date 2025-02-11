import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_search_bar.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_tile.dart';
import 'package:legwork/core/Constants/jobs_list.dart';

/**
 * THIS SCREEN PROMPTS THE USER TO INPUT THE TYPE OF JOBS HE IS INTERESTED IN
 * 
 * TODO: PROPERLY HANDLE THE STATE OF THE CHECKBOX
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
  final TextEditingController skillTypeController = TextEditingController();
  final SearchController searchController = SearchController();

  // Copy jobs list to stateful widget so it can be updated
  List<List<dynamic>> localJobs = [];

  @override
  void initState() {
    super.initState();
    localJobs = List.from(
        jobs); // Copy the jobs list to avoid modifying the global list
  }

  void checkBoxTapped(bool value, int index) {
    debugPrint('$index, $value');
    setState(() {
      localJobs[index][1] = value;
      if (value) {
        selectedSkills.add(localJobs[index][0]);
      } else {
        selectedSkills.remove(localJobs[index][0]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: Column(
            children: [
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
                      height: MediaQuery.of(context).size.height * 0.18,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'What type of work are you looking for?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Search for skills you have',
                              style: GoogleFonts.robotoSlab(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15.0),
                    child: Column(
                      children: [
                        JobSearchBar(
                          searchController: searchController,
                          suggestionsBuilder: (context, controller) {
                            final filteredJobs = localJobs.where(
                              (job) {
                                return controller.text.isEmpty ||
                                    job[0].toLowerCase().contains(
                                        controller.text.toLowerCase());
                              },
                            ).toList();

                            return [
                              SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  itemCount: filteredJobs.length,
                                  itemBuilder: (context, index) {
                                    final jobIndex = localJobs.indexWhere(
                                        (job) =>
                                            job[0] == filteredJobs[index][0]);

                                    // localJobs.indexOf(filteredJobs[index]);
                                    return JobTile(
                                      job: filteredJobs[index][0],
                                      checkedValue: localJobs[jobIndex][1],
                                      onChanged: (value) =>
                                          checkBoxTapped(value!, jobIndex),
                                    );
                                  },
                                ),
                              ),
                            ];
                          },
                        ),
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
                              Expanded(
                                child: ListView.builder(
                                  itemCount: selectedSkills.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
