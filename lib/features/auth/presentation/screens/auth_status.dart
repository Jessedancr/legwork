import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/Data/DataSources/auth_remote_data_source.dart';
import 'package:legwork/Features/home/presentation/screens/client_home_screen.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/app.dart';

import 'account_type_screen.dart';
/**
 * THIS IS TO CHECK IF THE USER IS LOGGED IN OR NOT
 * If user is logged in, show homescreen else show account type screen
 */

class AuthStatus extends StatelessWidget {
  final AuthRemoteDataSourceImpl authRemoteDataSource =
      AuthRemoteDataSourceImpl();
  AuthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: auth.authStateChanges(),
        builder: (context, snapShot) {
          // If no user is logged in, show the AccountTypeScreen
          if (!snapShot.hasData) {
            return const AccountTypeScreen();
          }
          // if user is logged in, show the appropriate home screen
          else {
            final user = snapShot.data;
            return FutureBuilder(
              future: authRemoteDataSource.getUserType(user!.uid),
              builder: (context, snapshot) {
                // Show a circular progress indicator while fetching user type
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                  );

                  // showLoadingIndicator(context);
                }
                final userType = snapshot.data;
                if (userType == 'dancer') {
                  return App();
                } else if (userType == 'client') {
                  return ClientHomeScreen();
                } else {
                  // If userType is unknown, default to AccountTypeScreen
                  return const AccountTypeScreen();
                }
              },
            );
          }
        },
      ),
    );
  }
}
