import 'package:flutter/material.dart';
import 'package:legwork/features/auth/presentation/screens/account_type_screen.dart';
import 'package:legwork/features/auth/presentation/screens/login_screen.dart';

// TODO : COME BACK TO TEST OUT MITCH KOKO'S LOGIC OF LOGIN OR REGISTER
class AccountTypeOrRegister extends StatefulWidget {
  const AccountTypeOrRegister({super.key});

  @override
  State<AccountTypeOrRegister> createState() => _AccountTypeOrRegisterState();
}

class _AccountTypeOrRegisterState extends State<AccountTypeOrRegister> {
  // Show Account type screen initially
  bool showAcctType = true;

  // Func to switch btw the two
  void toggleScreen() {
    setState(() {
      showAcctType = !showAcctType;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showAcctType == true) {
      return AccountTypeScreen();
    } else {
      return LoginScreen();
    }
  }
}
