import 'package:flutter/material.dart';

class JobsForYouNotifScreen extends StatefulWidget {
  const JobsForYouNotifScreen({super.key});

  @override
  State<JobsForYouNotifScreen> createState() => _JobsForYouNotifScreenState();
}

class _JobsForYouNotifScreenState extends State<JobsForYouNotifScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.amber,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
