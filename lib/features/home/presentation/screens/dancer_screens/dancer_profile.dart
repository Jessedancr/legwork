// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
// import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

// class DancerProfile extends StatefulWidget {
//   const DancerProfile({super.key});

//   @override
//   State<DancerProfile> createState() => _DancerProfileState();
// }

// class _DancerProfileState extends State<DancerProfile> {
//   late MyAuthProvider authProvider;
//   Map<String, dynamic>? dancerDetails;
//   bool isLoading = false;
//   late DancerEntity? dancer;

//   @override
//   void initState() {
//     super.initState();
//     authProvider = Provider.of<MyAuthProvider>(context, listen: false);
//     _fetchDancerDetails();
//   }

//   Future<void> _fetchDancerDetails() async {
//     final uid = authProvider.getUserId();
//     final result = await authProvider.getUserDetails(uid: uid);

//     result.fold(
//         // handle fail
//         (fail) {
//       debugPrint('Failed to get user details: $fail');
//       setState(() {
//         isLoading = false;
//       });
//     },

//         // handle success
//         (data) {
//       setState(() {
//         dancerDetails = data;
//         isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;
//     final userEmail = authProvider.getUserEmail();

//     // final dancerDetails = userDetails;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dancer Profile'),
//         backgroundColor: colorScheme.primary,
//         automaticallyImplyLeading: false,
//       ),
//       body: isLoading
//           ? Center(
//               child: Lottie.asset(
//                 'assets/lottie/loading.json',
//                 height: 150,
//                 width: 150,
//                 fit: BoxFit.contain,
//               ),
//             )
//           : dancerDetails == null
//               ? Center(
//                   child: Text(
//                     'Failed to load profile data',
//                     style: textTheme.bodyLarge
//                         ?.copyWith(color: colorScheme.onSurface),
//                   ),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Profile Picture
//                       Center(
//                         child: CircleAvatar(
//                           radius: 50,
//                           backgroundImage: dancer!.profilePicture != null
//                               ? NetworkImage(dancer!.profilePicture)
//                               : const AssetImage(
//                                   'images/depictions/dancer_dummy_default_profile_picture.jpg',
//                                 ) as ImageProvider,
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // Name
//                       Text(
//                         '${dancerDetails!['firstName']} ${dancerDetails!['lastName']}',
//                         style: textTheme.headlineSmall?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: colorScheme.onSurface,
//                         ),
//                       ),
//                       const SizedBox(height: 8),

//                       Text('Email: $userEmail'),

//                       // Username
//                       Text(
//                         '@${dancer!.username}',
//                         style: textTheme.bodyMedium?.copyWith(
//                           color: colorScheme.onSurfaceVariant,
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // Bio
//                       Text(
//                         'Bio:',
//                         style: textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: colorScheme.onSurface,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         dancer!.bio ?? 'No bio available',
//                         style: textTheme.bodyMedium?.copyWith(
//                           color: colorScheme.onSurfaceVariant,
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // Job Preferences
//                       Text(
//                         'Job Preferences:',
//                         style: textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: colorScheme.onSurface,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         dancer!.jobPrefs != null
//                             ? dancer!.jobPrefs.toString()
//                             : 'No job preferences available',
//                         style: textTheme.bodyMedium?.copyWith(
//                           color: colorScheme.onSurfaceVariant,
//                         ),
//                       ),
//                       const SizedBox(height: 16),

//                       // Resume
//                       Text(
//                         'Resume:',
//                         style: textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: colorScheme.onSurface,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         dancer!.resume != null
//                             ? dancer!.resume.toString()
//                             : 'No resume available',
//                         style: textTheme.bodyMedium?.copyWith(
//                           color: colorScheme.onSurfaceVariant,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/Models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
// import 'package:legwork/features/auth/domain/Entities/dancer_model.dart';

class DancerProfile extends StatefulWidget {
  const DancerProfile({super.key});

  @override
  State<DancerProfile> createState() => _DancerProfileState();
}

class _DancerProfileState extends State<DancerProfile> {
  late MyAuthProvider authProvider;
  DancerModel? dancerDetails;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    _fetchDancerDetails();
  }

  Future<void> _fetchDancerDetails() async {
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
          dancerDetails = data as DancerModel; // Cast to DancerModel
          isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dancer Profile'),
        backgroundColor: colorScheme.primary,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : dancerDetails == null
              ? Center(
                  child: Text(
                    'Failed to load profile data',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              (dancerDetails!.profilePicture != null &&
                                      dancerDetails!.profilePicture!.isNotEmpty)
                                  ? NetworkImage(dancerDetails!.profilePicture!)
                                  : const AssetImage(
                                      'images/depictions/dancer_dummy_default_profile_picture.jpg',
                                    ) as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Name
                      Text(
                        '${dancerDetails!.firstName} ${dancerDetails!.lastName}',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email
                      Text(
                        'Email: ${dancerDetails!.email}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bio
                      Text(
                        'Bio:',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dancerDetails!.bio ?? 'No bio available',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Job Preferences
                      Text(
                        'Job Preferences:',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dancerDetails!.jobPrefs != null
                            ? dancerDetails!.jobPrefs.toString()
                            : 'No job preferences available',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Resume
                      Text(
                        'Resume:',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        dancerDetails!.resume != null
                            ? dancerDetails!.resume.toString()
                            : 'No resume available',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
