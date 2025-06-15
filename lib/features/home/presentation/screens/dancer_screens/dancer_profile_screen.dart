import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/update_profile_provider.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_loading_indicator.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/view_profile_picture.dart';
import 'package:legwork/features/home/presentation/widgets/bio_card.dart';
import 'package:legwork/features/home/presentation/widgets/job_preferences_card.dart';
import 'package:legwork/features/home/presentation/widgets/profile_header_section.dart';
import 'package:legwork/features/home/presentation/widgets/resume_section.dart';
import 'package:legwork/features/home/presentation/widgets/work_experience_bottom_sheet.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';

class DancerProfileScreen extends StatefulWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController employerController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController jobDescrController = TextEditingController();
  DancerProfileScreen({super.key});

  @override
  State<DancerProfileScreen> createState() => _DancerProfileScreenState();
}

class _DancerProfileScreenState extends State<DancerProfileScreen> {
  late MyAuthProvider authProvider;
  DancerEntity? dancerDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    _fetchDancerDetails();
  }

  // FETCH DANCER DETAILS FROM BACKEND USING AUTH PROVIDER
  Future<void> _fetchDancerDetails() async {
    final uid = authProvider.getUserId();
    final result = await authProvider.getUserDetails(uid: uid);

    result.fold(
      (fail) {
        debugPrint('Failed to fetch dancer details: $fail');
        if (mounted) setState(() => isLoading = false);
      },
      (data) {
        if (mounted) {
          setState(() {
            dancerDetails = data as DancerEntity;
            isLoading = false;
          });
        }
      },
    );
  }

  void _navigateToEditProfile() {
    Navigator.pushNamed(
      context,
      '/editProfileScreen',
      arguments: dancerDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // DATE PICKER
    Future<void> datePicker() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (pickedDate != null) {
        setState(() {
          widget.dateController.text = pickedDate.toString().split(' ')[0];
        });
      }
    }

    void saveExperience() async {
      if (formKey.currentState!.validate()) {
        final provider =
            Provider.of<UpdateProfileProvider>(context, listen: false);

        final newExp = {
          'date': widget.dateController.text,
          'employer': widget.employerController.text,
          'jobDescription': widget.jobDescrController.text,
          'jobTitle': widget.titleController.text,
          'location': widget.locationController.text,
        };

        final currentExp = dancerDetails!.resume?['workExperiences'] ?? [];

        final updatedExp = [...currentExp, newExp];

        final data = {
          'resume.workExperiences': updatedExp,
        };

        showLoadingIndicator(context);
        final result = await provider.updateProfileExecute(data: data);

        result.fold(
            // handle failure
            (fail) {
          debugPrint(fail.toString());
          hideLoadingIndicator(context);
          Navigator.of(context).pop();
          LegworkSnackbar(
            title: 'Omo!',
            subTitle: fail,
            imageColor: colorScheme.onError,
            contentColor: colorScheme.error,
          ).show(context);

          // Clear controllers
          widget.dateController.clear();
          widget.employerController.clear();
          widget.jobDescrController.clear();
          widget.locationController.clear();
          widget.titleController.clear();
        },

            // handle success
            (_) {
          hideLoadingIndicator(context);

          // Notify parent widget of change
          if (dancerDetails != null) {
            dancerDetails!.resume!['workExperiences'] = updatedExp;
          }

          // Force UI update
          if (mounted) {
            setState(() {});
          }

          Navigator.of(context).pop();
          LegworkSnackbar(
            title: 'Sharp guy!',
            subTitle: 'Work experience added',
            imageColor: colorScheme.onPrimary,
            contentColor: colorScheme.primary,
          ).show(context);

          // Clear controllers
          widget.dateController.clear();
          widget.employerController.clear();
          widget.jobDescrController.clear();
          widget.locationController.clear();
          widget.titleController.clear();
        });
      }
    }

    // METHOD THAT SHOWS BOTTOM SHEET TO ADD WORK EXPERIENCE
    void addWorkExperience() {
      showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        context: context,
        builder: (context) {
          return WorkExperienceBottomSheet(
            onPressed: saveExperience,
            employerController: widget.employerController,
            titleController: widget.titleController,
            jobDescrController: widget.jobDescrController,
            locationController: widget.locationController,
            dateController: widget.dateController,
            showDatePicker: datePicker,
          );
        },
      );
    }

    return Scaffold(
      // * APP BAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          dancerDetails?.username != null
              ? dancerDetails!.username
              : 'Your Profile',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/svg/pen_circle.svg',
              color: colorScheme.onSurface,
              width: 24,
              height: 24,
            ),
            onPressed: _navigateToEditProfile,
          )
        ],
      ),

      // * FLOATING ACTION BUTTON
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              backgroundColor: colorScheme.primary,
              onPressed: addWorkExperience,
              child: Icon(Icons.add, color: context.colorScheme.onPrimary),
            ),

      // * BODY
      body: isLoading
          ? Center(
              child: Lottie.asset(
                'assets/lottie/loading.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            )
          : dancerDetails == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load profile data',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: _fetchDancerDetails,
                        child: isLoading
                            ? Lottie.asset(
                                'assets/lottie/loading.svg',
                                height: 20,
                                fit: BoxFit.contain,
                              )
                            : const Text('retry'),
                      ),
                    ],
                  ),
                )

              // LIQUID PULL TO REFRESH
              : LiquidPullToRefresh(
                  onRefresh: _fetchDancerDetails,
                  color: colorScheme.primary,
                  backgroundColor: colorScheme.surface,
                  animSpeedFactor: 3.0,
                  showChildOpacityTransition: false,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Header Section with Profile Picture
                        ProfileHeaderSection(
                          user: dancerDetails!,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ViewProfilePicture(
                                  defaultImagePath:
                                      'images/depictions/dancer_dummy_default_profile_picture.jpg',
                                ),
                              ),
                            );
                          },
                          defaultProfileImagePath:
                              'images/depictions/dancer_dummy_default_profile_picture.jpg',
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),

                              // Bio Section
                              BioCard(user: dancerDetails!),
                              const SizedBox(height: 20),

                              // Dance Preferences (Dance Styles & Job Types)
                              JobPreferencesCard(user: dancerDetails!),

                              const SizedBox(height: 20),

                              // Resume Section
                              ResumeSection(user: dancerDetails!),

                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
