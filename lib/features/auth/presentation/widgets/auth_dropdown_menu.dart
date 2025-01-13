/**
 * TODO: IMPLEMENT THIS WIDGET IN LOGIN SCREEN IF CANT FIND A WAY TO LOGIN WITHOUT EXPLICTILY ASKING USER FOR USERTYPE
 */
import 'package:flutter/material.dart';

class AuthDropDownMenu extends StatelessWidget {
  // final String selectedValue;
  final void Function(String?)? onChanged;
  final String? selectedValue = 'jesse';
  const AuthDropDownMenu({
    super.key,
    required this.onChanged,
    //required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      items: const [
        DropdownMenuItem(value: 'dancer', child: Text('dancer')),
        DropdownMenuItem(value: 'client', child: Text('client')),
      ],
      value: selectedValue,
      onChanged: onChanged,
    );
  }
}
