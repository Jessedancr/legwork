import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/job_application/presentation/screens/accpeted_applications.dart';
import 'package:legwork/features/job_application/presentation/screens/pending_applications.dart';
import 'package:legwork/features/job_application/presentation/screens/rejected_applications.dart';

class JobApplicationsScreen extends StatefulWidget {
  const JobApplicationsScreen({super.key});

  @override
  State<JobApplicationsScreen> createState() => _JobApplicationsScreenState();
}

class _JobApplicationsScreenState extends State<JobApplicationsScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _tabLabels = const ['Pending', 'Accepted', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabLabels.length,
      child: Scaffold(
        backgroundColor: context.colorScheme.surface,

        // * AppBar
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 40.0,
          elevation: 0,
          backgroundColor: context.colorScheme.surface,
          centerTitle: true,
          title: Text(
            'Job Applications',
            style: context.heading2Xs?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
              ),
              child: TabBar(
                indicatorColor: context.colorScheme.primary,
                indicatorWeight: 3,
                labelColor: context.colorScheme.secondary,
                unselectedLabelColor: context.colorScheme.secondary,
                labelStyle: context.textSm?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: context.textSm?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: _tabLabels[0]),
                  Tab(text: _tabLabels[1]),
                  Tab(text: _tabLabels[2])
                ],
              ),
            ),
          ),
        ),

        // * Body
        body: const TabBarView(
          children: [
            PendingApplications(),
            AcceptedApplications(),
            RejectedApplications(),
          ],
        ),
      ),
    );
  }
}
