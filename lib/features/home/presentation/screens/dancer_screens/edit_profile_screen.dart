import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/entities.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/core/Constants/jobs_list.dart';
import 'package:legwork/features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_button.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/widgets/job_search_bar.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_checkbox_tile.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_elevated_button.dart';
import 'package:legwork/core/Constants/lagos_locations.dart';
import 'package:legwork/features/home/presentation/widgets/edit_job_types_bottom_sheet.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_list_tile.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final DancerEntity? dancerDetails;

  const EditProfileScreen({super.key, required this.dancerDetails});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _danceStylesController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final SearchController searchController = SearchController();
  final TextEditingController _proTitleController = TextEditingController();
  late final UpdateProfileProvider provider;

  // Selected lists for dropdown/multi-select
  List<String> selectedDanceStyles = [];

  // This list holds all our locations
  List<LagosLocations> locations = [];
  List selectedJobTypes = [];

  // List of selected Locations to be shown to the user and send to the backend
  List selectedLocations = [];

  // Extracting the job from the jobs list
  final List<String> availableJobTypes =
      jobsList.map((job) => job[0] as String).toList();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    if (widget.dancerDetails != null) {
      _firstNameController.text = widget.dancerDetails!.firstName;
      _lastNameController.text = widget.dancerDetails!.lastName;
      _phoneNumberController.text = widget.dancerDetails!.phoneNumber;
      _usernameController.text = widget.dancerDetails!.username;
      _proTitleController.text =
          widget.dancerDetails!.resume?['professionalTitle'] ?? '';
      _danceStylesController.text =
          widget.dancerDetails!.jobPrefs!['danceStyles'].join(', ').toString();

      _emailController.text = widget.dancerDetails!.email;
      _bioController.text = widget.dancerDetails!.bio ?? '';

      // Initialize selected lists
      if (widget.dancerDetails!.jobPrefs != null &&
          widget.dancerDetails!.jobPrefs!['danceStyles'] is List &&
          widget.dancerDetails!.jobPrefs!['jobLocations'] is List) {
        selectedDanceStyles =
            List<String>.from(widget.dancerDetails!.jobPrefs!['danceStyles']);

        selectedLocations =
            List<String>.from(widget.dancerDetails!.jobPrefs!['jobLocations']);
      }

      locations = lagosLocations
          .map((location) =>
              LagosLocations(name: location[0], isSelected: location[1]))
          .toList();
    }
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // Handle profile update
  Future<void> _updateProfile() async {
    // Map containing the updated data
    final Map<String, dynamic> updatedProfile = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'username': _usernameController.text,
      'phoneNumber': _phoneNumberController.text,
      'email': _emailController.text,
      'bio': _bioController.text,
      'jobPrefs': {
        'danceStyles': _danceStylesController.text
            .trim()
            .split(RegExp(r'(\s*,\s)+'))
            .where((style) => style.isNotEmpty)
            .toList(),
        'jobTypes': selectedJobTypes,
        'jobLocations': selectedLocations,
      },
      'resume': {
        'professionalTitle': _proTitleController.text,
        'workExperiences':
            widget.dancerDetails!.resume?['workExperiences'] ?? [],
      }
    };

    showLoadingIndicator(context);
    provider = Provider.of<UpdateProfileProvider>(context, listen: false);
    await provider.updateProfileExecute(data: updatedProfile);
    hideLoadingIndicator(context);

    // Show success message and navigate back
    LegworkSnackbar(
      title: 'Sharp guy!',
      subTitle: 'Profile updated successfully',
      imageColor: Theme.of(context).colorScheme.onPrimary,
      contentColor: Theme.of(context).colorScheme.primary,
    ).show(context);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    //SCREEN SIZE
    final screenWidth = MediaQuery.of(context).size.width;

    // * JOB TYPES BOTTOM SHEET
    void openJobTypesBottomSheet() {
      if (widget.dancerDetails!.jobPrefs != null &&
          widget.dancerDetails!.jobPrefs!['jobTypes'] is List) {
        selectedJobTypes =
            List<String>.from(widget.dancerDetails!.jobPrefs!['jobTypes']);
      }
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return EditJobTypesBottomSheet(
              colorScheme: colorScheme,
              textTheme: textTheme,
              availableJobTypes: availableJobTypes,
              selectedJobTypes: selectedJobTypes,
              editProfileScreen: widget,
              onPressed: () {
                widget.dancerDetails!.jobPrefs?['jobTypes'] = selectedJobTypes;
                Navigator.of(context).pop();
              },
            );
          });
    }

    // * JOB LOCATIONS BOTTOM SHEET
    void openJobLocationsBottomSheet() {
      // * Copy of lagosLocations list
      final initialLocations = List<LagosLocations>.from(locations);

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
            // TODO!: COME BACK AND FIX THE FILTERED LIST NOT UPDATING STATE
            builder: (context, setModalState) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    JobSearchBar(
                      barHintText: 'Search locations',
                      searchController: searchController,
                      suggestionsBuilder: (context, controller) {
                        /// * Here we filter locations based on what the user has typed.
                        /// * If the user hasn't typed anything, return the full list.
                        /// * We do this using the .where() method and convert it to list
                        /// * because the .where() method returns an iterable.
                        final filtered = initialLocations.where((location) {
                          return controller.text.isEmpty ||
                              location.name
                                  .toLowerCase()
                                  .contains(controller.text.toLowerCase());
                        }).toList();

                        return [
                          SizedBox(
                            height: 400,
                            child: ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return LegworkCheckboxTile(
                                  title: filtered[index].name,
                                  checkedValue: filtered[index].isSelected,
                                  onChanged: (value) {
                                    setModalState(() {
                                      // Update the original location's state
                                      final originalIndex =
                                          locations.indexWhere((l) =>
                                              l.name == filtered[index].name);

                                      // If a match is found(originalIndex != -1),
                                      // update the isSelected value of that item to true/false
                                      if (originalIndex != -1) {
                                        locations[originalIndex].isSelected =
                                            value!;
                                        filtered[index].isSelected = true;
                                      }

                                      // // Update filtered list
                                      // filtered[index].isSelected = value!;

                                      /// * Update selectedLocations list
                                      /// * If the checkbox is ticked and the selectedLocations list
                                      /// * does not already contain the location from the
                                      /// * filteredLocations list then add it to the selectedLocations
                                      /// * else, remove it
                                      if (value! &&
                                          !selectedLocations
                                              .contains(filtered[index].name)) {
                                        selectedLocations
                                            .add(filtered[index].name);
                                      } else {
                                        selectedLocations
                                            .remove(filtered[index].name);
                                      }
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                        ];
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Selected Locations:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    // Display selected locations
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedLocations.map((location) {
                        return Chip(
                          label: Text(location),
                          onDeleted: () {
                            setModalState(() {
                              selectedLocations.remove(location);
                              final index = locations
                                  .indexWhere((l) => l.name == location);
                              if (index != -1) {
                                locations[index].isSelected = false;
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    AuthButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {}); // Refresh parent widget
                      },
                      buttonText: 'Done',
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    return Scaffold(
      // * APPBAR
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // * BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Profile picture + edit icon
            Center(
              child: Hero(
                tag: 'profile_picture',
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: (widget.dancerDetails?.profilePicture !=
                                  null &&
                              widget.dancerDetails!.profilePicture!.isNotEmpty)
                          ? NetworkImage(widget.dancerDetails!.profilePicture!)
                          : const AssetImage(
                              'images/depictions/dancer_dummy_default_profile_picture.jpg',
                            ) as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/svg/camera.svg',
                            fit: BoxFit.scaleDown,
                            color: colorScheme.onPrimary,
                          ),
                          color: colorScheme.onPrimary,
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // * Basic Information Edit Form
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Information',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AuthTextFormField(
                          width: screenWidth * 0.37,
                          obscureText: false,
                          controller: _firstNameController,
                          labelText: 'First name',
                          icon: SvgPicture.asset(
                            'assets/svg/user.svg',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        AuthTextFormField(
                          width: screenWidth * 0.37,
                          obscureText: false,
                          controller: _lastNameController,
                          labelText: 'Last name',
                          icon: SvgPicture.asset(
                            'assets/svg/user.svg',
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      prefixIcon: SvgPicture.asset(
                        'assets/svg/username.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Phone number
                    _buildTextField(
                      controller: _phoneNumberController,
                      label: 'Phone Number',
                      prefixIcon: SvgPicture.asset(
                        'assets/svg/hashtag_icon.svg',
                        fit: BoxFit.scaleDown,
                      ),
                      // keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      prefixIcon: SvgPicture.asset(
                        'assets/svg/mail.svg',
                        fit: BoxFit.scaleDown,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    LargeTextField(
                      maxLength: 300,
                      hintText: 'bio',
                      labelText: 'bio',
                      obscureText: false,
                      controller: _bioController,
                      icon: SvgPicture.asset(
                        'assets/svg/description_icon.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // * Professional title card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Title',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _proTitleController,
                      label: 'Professional title',
                      helperText:
                          'Professional title should be brief and concise',
                      prefixIcon: SvgPicture.asset(
                        'assets/svg/brand.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Dance Styles Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dance Styles',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      controller: _danceStylesController,
                      label: 'dance Styles',
                      helperText: 'Separate each dance style with a comma',
                      prefixIcon: SvgPicture.asset(
                        'assets/svg/disco_ball.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // * Job types list tile
            LegworkListTile(
              leading: SvgPicture.asset(
                'assets/svg/briefcase.svg',
                color: colorScheme.onPrimary,
                fit: BoxFit.scaleDown,
              ),
              title: Text(
                'Job types',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onPrimary,
                ),
              ),
              onTap: openJobTypesBottomSheet,
            ),
            const SizedBox(height: 20),

            // * Job locations list tile
            LegworkListTile(
              leading: SvgPicture.asset(
                'assets/svg/location.svg',
                color: colorScheme.onPrimary,
                fit: BoxFit.scaleDown,
              ),
              title: Text(
                'Job locations',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onPrimary,
                ),
              ),
              onTap: openJobLocationsBottomSheet,
            ),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: LegworkElevatedButton(
                onPressed: _updateProfile,
                buttonText: 'Update profile',
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Widget prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? helperText,
  }) {
    //SCREEN SIZE

    return AuthTextFormField(
      obscureText: false,
      controller: controller,
      labelText: label,
      icon: prefixIcon,
      keyboardType: keyboardType,
      helperText: helperText,
    );
  }
}
