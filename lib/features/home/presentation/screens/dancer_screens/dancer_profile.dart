import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/view_profile_picture.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';

class DancerProfile extends StatefulWidget {
  const DancerProfile({super.key});

  @override
  State<DancerProfile> createState() => _DancerProfileState();
}

class _DancerProfileState extends State<DancerProfile> {
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
        setState(() => isLoading = false);
      },
      (data) {
        setState(() {
          dancerDetails = data as DancerEntity;
          isLoading = false;
        });
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

    return Scaffold(
      // * ApPP BAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          dancerDetails?.username != null
              ? '@${dancerDetails!.username}'
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
                        child: const Text('Retry'),
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
                        _buildProfileHeader(colorScheme, textTheme),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),

                              // Bio Section
                              _buildBioSection(colorScheme, textTheme),

                              const SizedBox(height: 20),

                              // Contact Information
                              _buildContactSection(colorScheme, textTheme),

                              const SizedBox(height: 20),

                              // Dance Preferences (Dance Styles & Job Types)
                              _buildDancePreferencesSection(
                                  colorScheme, textTheme),

                              const SizedBox(height: 20),

                              // Resume Section
                              _buildResumeSection(colorScheme, textTheme),

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

  /**
   * * WIDGET FOR THE PROFILE HEADER SECTION
   */
  Widget _buildProfileHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.only(bottom: 24, top: 16),
      child: Column(
        children: [
          // Profile Picture
          Hero(
            tag: 'profile_picture',
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ViewProfilePicture(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 65,
                  backgroundColor: Colors.white,
                  backgroundImage: (dancerDetails!.profilePicture != null &&
                          dancerDetails!.profilePicture!.isNotEmpty)
                      ? NetworkImage(dancerDetails!.profilePicture!)
                      : const AssetImage(
                          'images/depictions/dancer_dummy_default_profile_picture.jpg',
                        ) as ImageProvider,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            '${dancerDetails!.firstName} ${dancerDetails!.lastName}',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),

          // Username
          Text(
            '@${dancerDetails!.username}',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection(ColorScheme colorScheme, TextTheme textTheme) {
    final hasBio = dancerDetails!.bio != null && dancerDetails!.bio!.isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Biography',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              hasBio ? dancerDetails!.bio! : 'No bio available yet.',
              style: textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: hasBio
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withOpacity(0.7),
                fontStyle: hasBio ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_phone, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Contact Information',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Phone
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.phone,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Phone',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              subtitle: Text(
                dancerDetails!.phoneNumber.toString(),
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Email
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.email,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              title: Text(
                'Email',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              subtitle: Text(
                dancerDetails!.email,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDancePreferencesSection(
      ColorScheme colorScheme, TextTheme textTheme) {
    final hasDanceStyles = dancerDetails!.jobPrefs?['danceStyles'] is List &&
        (dancerDetails!.jobPrefs?['danceStyles'] as List).isNotEmpty;
    final hasJobTypes = dancerDetails!.jobPrefs?['jobTypes'] is List &&
        (dancerDetails!.jobPrefs?['jobTypes'] as List).isNotEmpty;
    final hasJobLocations = dancerDetails!.jobPrefs?['jobLocations'] is List &&
        (dancerDetails!.jobPrefs?['jobLocations'] as List).isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.music_note, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Dance Preferences',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Dance Styles
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 16),
              initiallyExpanded: true,
              title: Row(
                children: [
                  Icon(
                    Icons.style,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Dance Styles',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              children: [
                if (hasDanceStyles)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (dancerDetails!.jobPrefs!['danceStyles'] as List)
                        .map((style) => Chip(
                              backgroundColor: colorScheme.primaryContainer,
                              label: Text(
                                style.toString(),
                                style: TextStyle(
                                  color: colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                else
                  Text(
                    'No dance styles specified',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

            // Job Types
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 16),
              initiallyExpanded: true,
              title: Row(
                children: [
                  Icon(
                    Icons.work,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Preferred Job Types',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              children: [
                if (hasJobTypes)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (dancerDetails!.jobPrefs!['jobTypes'] as List)
                        .map((type) => Chip(
                              backgroundColor: colorScheme.secondaryContainer,
                              label: Text(
                                type.toString(),
                                style: TextStyle(
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                else
                  Text(
                    'No job types specified',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),

            // Job Locations
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(bottom: 8),
              initiallyExpanded: true,
              title: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Preferred Job Locations',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              children: [
                if (hasJobLocations)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (dancerDetails!.jobPrefs!['jobLocations'] as List)
                        .map((location) => Chip(
                              backgroundColor: colorScheme.tertiaryContainer,
                              label: Text(
                                location.toString(),
                                style: TextStyle(
                                  color: colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                else
                  Text(
                    'No job locations specified',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeSection(ColorScheme colorScheme, TextTheme textTheme) {
    final hasResume = dancerDetails!.resume != null;
    final hasWorkExperiences = hasResume &&
        dancerDetails!.resume!['workExperiences'] is List &&
        (dancerDetails!.resume!['workExperiences'] as List).isNotEmpty;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Professional Resume',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Professional Title
            if (hasResume)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Title',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dancerDetails!.resume!['professionalTitle'] ??
                          'Not specified',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              Text(
                'No professional title specified',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),

            const SizedBox(height: 16),

            // Work Experience
            Text(
              'Work Experience',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),

            if (hasWorkExperiences)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    (dancerDetails!.resume!['workExperiences'] as List).length,
                itemBuilder: (context, index) {
                  final experience =
                      dancerDetails!.resume!['workExperiences'][index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: colorScheme.outlineVariant,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  experience['jobTitle']
                                          ?.toString()
                                          .toUpperCase() ??
                                      'Position',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  experience['date']?.toString() ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildResumeDetailItem(
                            Icons.business,
                            'Employer',
                            experience['employer']?.toString() ?? 'N/A',
                            colorScheme,
                            textTheme,
                          ),
                          const SizedBox(height: 4),
                          _buildResumeDetailItem(
                            Icons.location_city,
                            'Location',
                            experience['location']?.toString() ?? 'N/A',
                            colorScheme,
                            textTheme,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Description:',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            experience['jobDescription']?.toString() ??
                                'No description available',
                            style: textTheme.bodyMedium?.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.work_off,
                        size: 48,
                        color: colorScheme.onSurface.withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No work experience added yet',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeDetailItem(
    IconData icon,
    String label,
    String value,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.primary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$label: ',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
              children: [
                TextSpan(
                  text: value,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
