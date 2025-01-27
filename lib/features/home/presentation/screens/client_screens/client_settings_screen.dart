import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/Features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/Features/auth/presentation/widgets/auth_button.dart';
import 'package:provider/provider.dart';

class ClientSettingsScreen extends StatefulWidget {
  const ClientSettingsScreen({super.key});

  @override
  State<ClientSettingsScreen> createState() => _ClientSettingsScreenState();
}

class _ClientSettingsScreenState extends State<ClientSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    // Auth Provider
    var authProvider = Provider.of<MyAuthProvider>(context);

    //  Logout method
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('CLIENTS SETTINGS SCREEN'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AuthButton(
              onPressed: logout,
              buttonText: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
