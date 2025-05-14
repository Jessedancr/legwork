import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/view_profile_picture.dart';
import 'package:legwork/features/home/presentation/widgets/bio_card.dart';
import 'package:legwork/features/home/presentation/widgets/job_preferences_card.dart';
import 'package:legwork/features/home/presentation/widgets/profile_header_section.dart';
import 'package:legwork/features/home/presentation/widgets/resume_section.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  late MyAuthProvider authProvider;
  ClientEntity? clientDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    _fetchClientDetails();
  }

  Future<void> _fetchClientDetails() async {
    final uid = authProvider.getUserId();

    final result = await authProvider.getUserDetails(uid: uid);

    result.fold(
      (fail) {
        debugPrint('Failed to fetch dancer details: $fail');
        setState(() {
          isLoading = false;
        });
      },
      (data) {
        setState(() {
          clientDetails = data as ClientEntity; // Cast to ClientEntity
          isLoading = false;
        });
      },
    );
  }

  void _navigateToEditProfile() {
    Navigator.pushNamed(
      context,
      '/editClientProfileScreen',
      arguments: clientDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // * APP BAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          clientDetails?.username != null
              ? clientDetails!.username
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
      body: isLoading
          ? Center(
              child: Lottie.asset(
                'assets/lottie/loading.json',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            )
          : clientDetails == null
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
                        onPressed: _fetchClientDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )

              // PULL TO REFRESH
              : LiquidPullToRefresh(
                  onRefresh: _fetchClientDetails,
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
                          user: clientDetails!,
                          colorScheme: colorScheme,
                          textTheme: textTheme,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ViewProfilePicture(
                                  defaultImagePath:
                                      'images/depictions/img_depc1.jpg',
                                ),
                              ),
                            );
                          },
                          defaultProfileImagePath:
                              'images/depictions/img_depc1.jpg',
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),

                              // Bio Section
                              BioCard(user: clientDetails!),
                              const SizedBox(height: 20),

                              // Job Preferences (Dance Styles & Job Types)
                              JobPreferencesCard(
                                user: clientDetails!,
                              ),

                              // const SizedBox(height: 20),

                              // // Resume Section
                              ResumeSection(user: clientDetails!),

                              // const SizedBox(height: 24),
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
