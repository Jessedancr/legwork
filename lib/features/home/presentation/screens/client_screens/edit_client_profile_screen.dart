import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/jobs_list.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_text_form_field.dart';
import 'package:legwork/features/auth/presentation/widgets/large_textfield.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_elevated_button.dart';
import 'package:legwork/features/home/presentation/widgets/edit_job_types_bottom_sheet.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_list_tile.dart';
import 'package:provider/provider.dart';

class EditClientProfileScreen extends StatefulWidget {
  final ClientEntity clientDetails;
  const EditClientProfileScreen({
    super.key,
    required this.clientDetails,
  });

  @override
  State<EditClientProfileScreen> createState() =>
      _EditClientProfileScreenState();
}

class _EditClientProfileScreenState extends State<EditClientProfileScreen> {
  // Form controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _danceStylesController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _organisationNameController =
      TextEditingController();
  final TextEditingController _proTitleController = TextEditingController();

  // Selected lists for dropdown/multi-select
  List<String> selectedDanceStyles = [];
  List<String> selectedJobTypes = [];

  final SearchController searchController = SearchController();
  late final UpdateProfileProvider provider;

  // Extracting the job from the jobs list
  final List<String> availableJobTypes =
      jobsList.map((job) => job[0] as String).toList();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _firstNameController.text = widget.clientDetails.firstName;
    _lastNameController.text = widget.clientDetails.lastName;
    _phoneNumberController.text = widget.clientDetails.phoneNumber;
    _usernameController.text = widget.clientDetails.username;
    _organisationNameController.text =
        widget.clientDetails.organisationName ?? '';
    _danceStylesController.text =
        widget.clientDetails.danceStylePrefs!.join(', ').toString();

    _emailController.text = widget.clientDetails.email;
    _bioController.text = widget.clientDetails.bio ?? '';
    _proTitleController.text =
        widget.clientDetails.hiringHistory?['professionalTitle'] ?? '';

    // Initialize selected lists
    if (widget.clientDetails.danceStylePrefs!.isNotEmpty ||
        widget.clientDetails.jobOfferings!.isNotEmpty) {
      selectedDanceStyles =
          List<String>.from(widget.clientDetails.danceStylePrefs as Iterable);

      selectedJobTypes =
          List<String>.from(widget.clientDetails.jobOfferings as Iterable);
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
    _proTitleController.dispose();
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
      'jobOfferings': selectedJobTypes,
      'hiringHistory.professionalTitle': _proTitleController.text,
      'danceStylePrefs': _danceStylesController.text
          .trim()
          .split(RegExp(r'(\s*,\s)+'))
          .where((style) => style.isNotEmpty)
          .toList(),
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
      if (widget.clientDetails.jobOfferings!.isNotEmpty) {
        selectedJobTypes =
            List<String>.from(widget.clientDetails.jobOfferings as Iterable);
      }
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return EditJobTypesBottomSheet(
           
              availableJobTypes: availableJobTypes,
              selectedJobTypes: selectedJobTypes,
              editProfileScreen: widget,
              onPressed: () {
                widget.clientDetails.jobOfferings = selectedJobTypes;
                Navigator.of(context).pop();
              },
            );
          });
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
          children: [
            // * Profile picture + edit icon
            Center(
              child: Hero(
                tag: 'profile_picture_${widget.clientDetails.email}',
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: (widget.clientDetails.profilePicture !=
                                  null &&
                              widget.clientDetails.profilePicture!.isNotEmpty)
                          ? NetworkImage(widget.clientDetails.profilePicture!)
                          : const AssetImage(
                              'images/depictions/img_depc1.jpg',
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

            // Basic Information Edit Form
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

                    // Username
                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      prefixIcon: SvgPicture.asset(
                        'assets/svg/username.svg',
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Organisation name
                    _buildTextField(
                      controller: _organisationNameController,
                      label: 'Organisation name',
                      prefixIcon: SvgPicture.asset(
                        'assets/svg/briefcase.svg',
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

            // Professional title card
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
                      'Professional title',
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
