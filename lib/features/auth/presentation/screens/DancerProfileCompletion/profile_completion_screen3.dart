import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/entities.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/presentation/Widgets/blur_effect.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_search_bar.dart';

import 'package:legwork/core/Constants/lagos_locations.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_checkbox_tile.dart';

// Track selected skills
final List selectedLocations = [];

class ProfileCompletionScreen3 extends StatefulWidget {
  const ProfileCompletionScreen3({super.key});

  @override
  State<ProfileCompletionScreen3> createState() =>
      _ProfileCompletionScreen3State();
}

class _ProfileCompletionScreen3State extends State<ProfileCompletionScreen3> {
  // CONTROLLERS
  final SearchController searchController = SearchController();

  List<LagosLocations> locations = [];
  @override
  void initState() {
    super.initState();

    locations = lagosLocations
        .map((location) =>
            LagosLocations(name: location[0], isSelected: location[1]))
        .toList();
  }

  void checkBoxTapped(bool value, int index) {
    debugPrint('$index, $value');
    setState(() {
      locations[index].isSelected = value;
      if (value) {
        // Add the skill to the selected skills list
        selectedLocations.add(locations[index].name);
      } else {
        // Remove the skill from the selected skills list
        selectedLocations.remove(locations[index].name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                      secondGradientColor:
                          context.colorScheme.primary.withOpacity(0.5),
                      height: screenHeight(context) * 0.2,
                      width: screenWidth(context) * 0.8,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'What are your preferred job locations',
                                textAlign: TextAlign.center,
                                style: context.text2Xl?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.surface,
                                ),
                              ),
                              Text(
                                'This would help us better recommend jobs to you',
                                textAlign: TextAlign.center,
                                style: context.textXl?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: context.colorScheme.surface,
                                ),
                              ),
                              Text(
                                'Search for locations in Lagos',
                                style: context.textSm?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: context.colorScheme.surface,
                                ),
                              )
                            ],
                          ),
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
                        LegworkSearchBar(
                          barHintText: 'Search locations',
                          searchController: searchController,
                          suggestionsBuilder: (context, controller) {
                            // Filter locations based on the search query
                            final filteredLocations = locations.where(
                              (location) {
                                // Return empty search controller or the search query converted to lower case
                                return controller.text.isEmpty ||
                                    location.name.toLowerCase().contains(
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
                                      itemCount: filteredLocations.length,
                                      itemBuilder: (context, index) {
                                        final locationIndex =
                                            locations.indexWhere((location) =>
                                                location.name ==
                                                filteredLocations[index].name);
                                        return LegworkCheckboxTile(
                                          title: filteredLocations[index].name,
                                          checkedValue: filteredLocations[index]
                                              .isSelected,
                                          onChanged: (value) {
                                            checkBoxTapped(
                                              value!,
                                              locationIndex,
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

                        // SHOW SELECTED SKILLS
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Selected Locations:',
                                style: context.textXl?.copyWith(
                                  color: context.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

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
