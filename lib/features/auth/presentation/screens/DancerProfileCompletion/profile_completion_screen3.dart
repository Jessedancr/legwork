import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:legwork/Features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_search_bar.dart';
import 'package:legwork/Features/auth/presentation/Widgets/job_tile.dart';
import 'package:legwork/core/Constants/lagos_locations.dart';

// Track selected skills
final List selectedLocations = [];

class ProfileCompletionScreen3 extends StatefulWidget {
  const ProfileCompletionScreen3({super.key});

  @override
  State<ProfileCompletionScreen3> createState() =>
      _ProfileCompletionScreen3State();
}

class _ProfileCompletionScreen3State extends State<ProfileCompletionScreen3> {
  @override
  Widget build(BuildContext context) {
    // CONTROLLERS
    final TextEditingController skillTypeController = TextEditingController();
    final SearchController searchController = SearchController();

    void checkBoxTapped(bool value, int index) {
      debugPrint('$index, $value');
      setState(() {
        lagosLocations[index][1] = value;
        if (value) {
          // Add the skill to the selected skills list
          selectedLocations.add(lagosLocations[index][0]);
        } else {
          // Remove the skill from the selected skills list
          selectedLocations.remove(lagosLocations[index][0]);
        }
      });
    }

    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;


    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
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
                  ),
                  child: Center(
                    child: BlurEffect(
                      height: screenHeight * 0.18,
                      width: screenWidth * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'What are your preferred locations for jobs',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'This would help us better recommend jobs to you',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.robotoSlab(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Search for locations in Lagos',
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

              // EXPANDED WIDGET FOR OTHER SCREEN CONTENTS
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
                      horizontal: 15.0,
                      vertical: 15.0,
                    ),
                    child: Column(
                      children: [
                        // Search bar
                        JobSearchBar(
                          searchController: searchController,
                          suggestionsBuilder: (context, controller) {
                            // Filter locations based on the search query
                            final filteredLocations = lagosLocations.where(
                              (job) {
                                // Return empty search controller or the search query converted to lower case
                                return controller.text.isEmpty ||
                                    job[0].toLowerCase().contains(
                                        controller.text.toLowerCase());
                              },
                            ).toList();

                            // Display filtered results in a single listview
                            return [
                              SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  itemCount: filteredLocations.length,
                                  itemBuilder: (context, index) {
                                    final locationIndex = lagosLocations
                                        .indexOf(filteredLocations[index]);
                                    return JobTile(
                                      job: filteredLocations[index][0],
                                      checkedValue: filteredLocations[index][1],
                                      onChanged: (value) => checkBoxTapped(
                                        value!,
                                        locationIndex,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ];
                          },
                        ),

                        // SHOW SELECTED SKILLS
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Selected Locations:',
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
                                  itemCount: selectedLocations.length,
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
                                        '- ${selectedLocations[index]}',
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
