import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/DataSources/auth_remote_data_source.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/home/presentation/screens/client_screens/client_app.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_app.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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
    // Instance of auth provider
    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    return Scaffold(
      body: FutureBuilder(
        future: authProvider.getUid(),
        builder: (context, uidSnapshot) {
          if (uidSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/loading.json',
                height: 100,
                fit: BoxFit.cover,
              ),
            );
          }
          final uid = uidSnapshot.data;
          return FutureBuilder(
            future: authProvider.getUserDetails(uid: uid!),
            builder: (context, userDetailsSnapshot) {
              // Show a loading indicator while fetching user type
              if (userDetailsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: Lottie.asset(
                    'assets/lottie/loading.json',
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }
              final userType = userDetailsSnapshot.data!.fold(
                (fail) {
                  debugPrint('Error fetching user type: $fail');
                  return fail;
                },
                (userEntity) => userEntity.userType,
              );
              if (userType == 'dancer') {
                return const DancerApp();
              } else if (userType == 'client') {
                return const ClientApp();
              } else {
                // If userType is unknown, default to AccountTypeScreen
                return const AccountTypeScreen();
              }
            },
          );
        },
      ),
    );
  }
}
