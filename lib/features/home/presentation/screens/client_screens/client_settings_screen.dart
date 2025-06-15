import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/widgets/auth_button.dart';
import 'package:legwork/features/auth/presentation/widgets/legwork_elevated_button.dart';
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
            LegworkSnackbar(
              title: 'Omo!',
              subTitle: fail,
              imageColor: context.colorScheme.onError,
              contentColor: context.colorScheme.error,
            ).show(context);
          },
          // handle successful logout
          (success) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/acctType', (route) => false);
            debugPrint('Logout successful');
          },
        );
        debugPrint('Logout successful');
      } catch (e) {
        debugPrint('Logout failed: $e');
      }
    }

    // RETURNED WIDGET
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: context.heading2Xs?.copyWith(
            color: context.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.colorScheme.onSurface,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegworkElevatedButton(
              onPressed: logout,
              buttonText: 'logout',
              backgroundColor: context.colorScheme.error,
              icon: Icon(Icons.logout, color: context.colorScheme.onError),
              maximumSize: Size(screenWidth(context) * 0.4, 50),
            )
          ],
        ),
      ),
    );
  }
}
