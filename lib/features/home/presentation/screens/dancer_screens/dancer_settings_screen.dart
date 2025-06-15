import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/core/Constants/theme_provider.dart';
import 'package:legwork/core/widgets/legwork_snackbar.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';
import 'package:legwork/features/auth/presentation/Widgets/auth_loading_indicator.dart';
import 'package:legwork/features/auth/presentation/Widgets/legwork_elevated_button.dart';
import 'package:legwork/features/home/presentation/widgets/legwork_list_tile.dart';
import 'package:provider/provider.dart';

class DancerSettingsScreen extends StatefulWidget {
  const DancerSettingsScreen({super.key});

  @override
  State<DancerSettingsScreen> createState() => _DancerSettingsScreenState();
}

class _DancerSettingsScreenState extends State<DancerSettingsScreen> {
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
      } catch (e) {
        debugPrint('Logout failed: $e');
      }
    }

    // RETURNED WIDGET
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colorScheme.surface,
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
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              LegworkListTile(
                leading: Text(
                  'Dark mode',
                  style: context.textSm?.copyWith(
                    color: context.colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
                trailingWidget: CupertinoSwitch(
                  value: context.watch<ThemeProvider>().isDarkMode,
                  onChanged: (value) {
                    context.read<ThemeProvider>().toggleTheme();
                  },
                ),
              ),
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
      ),
    );
  }
}
