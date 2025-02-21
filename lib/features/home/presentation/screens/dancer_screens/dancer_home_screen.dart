import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/presentation/Widgets/legwork_snackbar_content.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_tabs/all_jobs.dart';
import 'package:legwork/Features/home/presentation/screens/dancer_screens/dancer_tabs/jobs_for_you.dart';
import 'package:legwork/Features/home/presentation/widgets/dancers_drawer.dart';

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
        drawer: const DancersDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
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
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
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
