import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';

import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_tabs/all_jobs.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_tabs/jobs_for_you.dart';
import 'package:legwork/features/home/presentation/widgets/dancers_drawer.dart';

class DancerHomeScreen extends StatefulWidget {
  const DancerHomeScreen({super.key});

  @override
  State<DancerHomeScreen> createState() => _DancerHomeScreenState();
}

class _DancerHomeScreenState extends State<DancerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //* Drawer
        drawer: const DancersDrawer(),

        //* AppBar
        appBar: AppBar(
          backgroundColor: context.colorScheme.surface,
          elevation: 0,
          centerTitle: true,
          title: const TabBar(
            tabs: [
              Tab(text: 'All Jobs'),
              Tab(text: 'for you'),
            ],
          ),
          leading: Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
        ),

        //* Body
        body: const TabBarView(
          children: [
            AllJobs(),
            JobsForYou(),
          ],
        ),
      ),
    );
  }
}
