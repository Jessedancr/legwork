import 'package:flutter/material.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your profile'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            )
          : clientDetails == null
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
                      // * PROFILE PICTURE
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              (clientDetails!.profilePicture != null &&
                                      clientDetails!.profilePicture!.isNotEmpty)
                                  ? NetworkImage(clientDetails!.profilePicture!)
                                  : const AssetImage(
                                      'images/depictions/img_depc1.jpg',
                                    ) as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // * NAME
                      Text(
                        '${clientDetails!.firstName} ${clientDetails!.lastName}',
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Username
                      Text('Username: ${clientDetails!.username}'),
                      const SizedBox(height: 8),

                      // * ORGANISATION NAME
                      Text(
                        clientDetails!.organisationName != null
                            ? 'Organisation name: ${clientDetails!.organisationName}'
                            : '',
                      ),
                      const SizedBox(height: 8),

                      // * PHONE NUMBER
                      Text('Phone number: ${clientDetails!.phoneNumber}'),
                      const SizedBox(height: 8),

                      // * EMAIL
                      Text(
                        'Email: ${clientDetails!.email}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // * BIO
                      Text(
                        'Bio:',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        clientDetails!.bio ?? 'No bio available',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }
}
