import 'package:flutter/material.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_snackbar_content.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_button.dart';
import 'package:provider/provider.dart';

class DancerSettingsScreen extends StatefulWidget {
  const DancerSettingsScreen({super.key});

  @override
  State<DancerSettingsScreen> createState() => _DancerSettingsScreenState();
}

class _DancerSettingsScreenState extends State<DancerSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    //SCREEN SIZE
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 5),
              content: LegWorkSnackBarContent(
                screenHeight: screenHeight,
                context: context,
                screenWidth: screenWidth,
                title: 'Oh Snap!',
                subTitle: fail,
                contentColor: Theme.of(context).colorScheme.error,
                imageColor: Theme.of(context).colorScheme.onError,
              ),
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
        title: const Text('DANCER SETTINGS SCREEN'),
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
