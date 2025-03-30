import 'package:flutter/material.dart';

class RejectedApplications extends StatefulWidget {
  const RejectedApplications({super.key});

  @override
  State<RejectedApplications> createState() => _RejectedApplicationsState();
}

class _RejectedApplicationsState extends State<RejectedApplications> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Rejected Applications'),
    );
  }
}
