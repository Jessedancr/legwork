import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/Widgets/large_textfield.dart';
import 'package:provider/provider.dart';

import '../../Provider/update_profile_provider.dart';

// TODO: PROPERLY FILL OUT THIS UI
class ProfileCompletionScreen1 extends StatefulWidget {
  final String? email;

  const ProfileCompletionScreen1({
    super.key,
    required this.email,
  });

  @override
  State<ProfileCompletionScreen1> createState() =>
      _ProfileCompletionScreen1State();
}

class _ProfileCompletionScreen1State extends State<ProfileCompletionScreen1> {
  // CONTROLLERS
  final bioController = TextEditingController();

  // Instance of firebase auth
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // PROVIDER
    final updateProfileProvider = Provider.of<UpdateProfileProvider>(context);

    // SAVE AND UPDATE PROFILE
    void saveAndUpdateProfile() async {
      showLoadingIndicator(context);
      try {
        await updateProfileProvider.updateProfileExecute(
          data: {
            'bio': bioController.text,
          },
        );
        hideLoadingIndicator(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bio saved'),
          ),
        );
      } catch (e) {
        debugPrint('error updating profile');
        hideLoadingIndicator(context);
        debugPrint('Error updating profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }

      debugPrint('SAVED BIO');
    }

    // RETURNED SCAFFOLD
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          children: [
            // WELCOME MESAAGE
            const Text('WELCOME TO LEGWORK!. Let\'s get your profile set up'),
            const SizedBox(height: 10),
            Text('Signed in as: ${widget.email!}'),
            const SizedBox(height: 30),

            // CONTAINER FOR PROFILE PICTURE
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(Icons.person),
              ),
            ),

            const SizedBox(height: 20),

            // TEXT FIELD FOR BIO
            LargeTextField(
              hintText: 'Enter your bio',
              obscureText: false,
              controller: bioController,
              icon: Icons.pending_actions,
            ),
            const SizedBox(height: 20),

            // SAVE BUTTON
            ElevatedButton(
              onPressed: saveAndUpdateProfile,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
