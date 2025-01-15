import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_textfield.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_search_bar.dart';

class ProfileCompletionScreen2 extends StatefulWidget {
  const ProfileCompletionScreen2({super.key});

  @override
  State<ProfileCompletionScreen2> createState() =>
      _ProfileCompletionScreen2State();
}

class _ProfileCompletionScreen2State extends State<ProfileCompletionScreen2> {
  // CONTROLLERS
  final TextEditingController skillTypeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      body: Center(
        child: Column(
          children: [
            const Text('What type of work are you looking for?'),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 60),
              child: Row(
                children: [
                  Text('Your skills'),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // TEXT FIELD FOR JOB TYPE
            // AuthTextfield(
            //   hintText: 'Enter skills',
            //   obscureText: false,
            //   controller: skillTypeController,
            //   icon: Icons.work,
            // ),

            LegworkSearchBar()
          ],
        ),
      ),
    );
  }
}


