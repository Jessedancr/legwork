import 'package:flutter/material.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ViewProfilePicture extends StatefulWidget {
  final String defaultImagePath;
  const ViewProfilePicture({
    super.key,
    required this.defaultImagePath,
  });

  @override
  State<ViewProfilePicture> createState() => _ViewProfilePictureState();
}

class _ViewProfilePictureState extends State<ViewProfilePicture> {
  late MyAuthProvider authProvider;
  UserEntity? userDetails;
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
          userDetails = data as UserEntity;
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
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
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
          : userDetails == null
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
              : Center(
                  child: Hero(
                    tag: 'profile_picture',
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
                        radius: MediaQuery.of(context).size.width * 0.45,
                        backgroundColor: colorScheme.surface,
                        backgroundImage: (userDetails!.profilePicture != null &&
                                userDetails!.profilePicture!.isNotEmpty)
                            ? NetworkImage(userDetails!.profilePicture!)
                            :  AssetImage(
                                widget.defaultImagePath,
                              ) as ImageProvider,
                      ),
                    ),
                  ),
                ),
    );
  }
}
