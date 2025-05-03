import 'package:flutter/material.dart';
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
  late TabController _tabController;
  final List<String> _tabLabels = const ['Pending', 'Accepted', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      // * AppBar
      appBar: AppBar(
        toolbarHeight: 40.0,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        centerTitle: true,
        title: Text(
          'Job Applications',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1.0,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.deepPurple.shade500,
              indicatorWeight: 3,
              labelColor: Colors.deepPurple.shade500,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              unselectedLabelStyle: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
              tabs: _buildTabs(),
            ),
          ),
        ),
      ),

      // * Body
      body: TabBarView(
        controller: _tabController,
        children: const [
          PendingApplications(),
          AcceptedApplications(),
          RejectedApplications(),
        ],
      ),
    );
  }

  List<Widget> _buildTabs() {
    return _tabLabels
        .map((label) => Tab(
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: _tabController.index == _tabLabels.indexOf(label)
                      ? 14
                      : 11,
                  fontWeight: _tabController.index == _tabLabels.indexOf(label)
                      ? FontWeight.w600
                      : FontWeight.w300,
                  color: _tabController.index == _tabLabels.indexOf(label)
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
                child: Text(label),
              ),
            ))
        .toList();
  }
}
