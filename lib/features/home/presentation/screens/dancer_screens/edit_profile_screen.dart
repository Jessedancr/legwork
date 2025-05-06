import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/core/Constants/jobs_list.dart';
import 'package:legwork/features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/Widgets/large_textfield.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_text_form_field.dart';
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
  late final UpdateProfileProvider provider;

  // Selected lists for dropdown/multi-select
  List<String> selectedDanceStyles = [];
  List selectedJobTypes = [];

  // Sample options for dance styles and job types (replace with your actual data)
  final List<String> availableDanceStyles = [
    'Ballet',
    'Contemporary',
    'Hip-Hop',
    'Jazz',
    'Tap',
    'Ballroom',
    'Latin'
  ];

  final List<String> availableJobTypes =
      jobs.map((job) => job[0] as String).toList();

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data
    if (widget.dancerDetails != null) {
      _firstNameController.text = widget.dancerDetails!.firstName;
      _lastNameController.text = widget.dancerDetails!.lastName;
      _phoneNumberController.text = widget.dancerDetails!.phoneNumber;

      _emailController.text = widget.dancerDetails!.email;
      _bioController.text = widget.dancerDetails!.bio ?? '';

      // Initialize selected lists
      if (widget.dancerDetails!.jobPrefs != null) {
        if (widget.dancerDetails!.jobPrefs!['danceStyles'] is List) {
          selectedDanceStyles =
              List<String>.from(widget.dancerDetails!.jobPrefs!['danceStyles']);
        }
        if (widget.dancerDetails!.jobPrefs!['jobTypes'] is List) {
          selectedJobTypes =
              List<String>.from(widget.dancerDetails!.jobPrefs!['jobTypes']);
        }
      }
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
      'phoneNumber': _phoneNumberController.text,
      'email': _emailController.text,
      'bio': _bioController.text,
      'jobPrefs': {
        'danceStyles': selectedDanceStyles,
        'jobTypes': selectedJobTypes,
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

            // Edit Form
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

                    // Contact Fields
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
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableDanceStyles.map((style) {
                        final isSelected = selectedDanceStyles.contains(style);
                        return FilterChip(
                          label: Text(style),
                          selected: isSelected,
                          selectedColor: colorScheme.primaryContainer,
                          checkmarkColor: colorScheme.primary,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedDanceStyles.add(style);
                              } else {
                                selectedDanceStyles.remove(style);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Job Types Card
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
                      'Job Preferences',
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableJobTypes.map((type) {
                        final isSelected = selectedJobTypes.contains(type);

                        return FilterChip(
                          label: Text(type),
                          selected: isSelected,
                          selectedColor: colorScheme.primaryContainer,
                          checkmarkColor: colorScheme.primary,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                selectedJobTypes.add(type);
                              } else {
                                selectedJobTypes.remove(type);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: _updateProfile,
                child: const Text(
                  'Save Profile',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
  }) {
    //SCREEN SIZE

    return AuthTextFormField(
      obscureText: false,
      controller: controller,
      labelText: label,
      icon: prefixIcon,
      keyboardType: keyboardType,
    );
  }
}
