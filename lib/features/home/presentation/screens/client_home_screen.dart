import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_button.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:provider/provider.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    // Dummy logout method
    void logout() async {
      // show loading indicator
      showLoadingIndicator(context);

      try {
        final result = await authProvider.logout();
        if (mounted) hideLoadingIndicator(context);

        result.fold(
            // handle failed logout
            (fail) {
          debugPrint('Logout failed: $fail');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).colorScheme.error,
              content: Text(fail),
            ),
          );
        },
            // handle successful logout
            (success) {
          debugPrint('Logout successful');
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/acctType', (route) => false);
        });
        debugPrint('Logout successful');
      } catch (e) {
        debugPrint('Logout failed: $e');
      }
    }

    // RETURNED WIDGET
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: const Drawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'CLIENTS HOME SCREEN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Sample Logout button
              AuthButton(
                onPressed: logout,
                buttonText: 'log out',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
