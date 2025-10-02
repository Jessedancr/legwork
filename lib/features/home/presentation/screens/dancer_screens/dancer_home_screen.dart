import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/presentation/Provider/my_auth_provider.dart';

import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_tabs/all_jobs.dart';
import 'package:legwork/features/home/presentation/screens/dancer_screens/dancer_tabs/jobs_for_you.dart';
import 'package:legwork/features/home/presentation/widgets/dancers_drawer.dart';
import 'package:provider/provider.dart';

class DancerHomeScreen extends StatefulWidget {
  const DancerHomeScreen({super.key});

  @override
  State<DancerHomeScreen> createState() => _DancerHomeScreenState();
}

class _DancerHomeScreenState extends State<DancerHomeScreen> {
  UserEntity? dancerDetails = UserEntity(
    username: '',
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    phoneNumber: '',
    userType: '',
    deviceToken: '',
  );
  late MyAuthProvider authProvider;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      setState(() {
        dancerDetails = authProvider.currentUser as DancerEntity;
        isLoading = false;
      });
    }
    _fetchDancerDetails();
  }

  Future<void> _fetchDancerDetails() async {
    final userId = await authProvider.getUid();
    final result = await authProvider.getUserDetails(uid: userId);

    result.fold(
      (fail) {
        debugPrint('Failed to fetch dancer details: $fail');
        if (mounted) setState(() => isLoading = false);
      },
      (data) {
        if (mounted) {
          setState(() {
            dancerDetails = data as DancerEntity;
            isLoading = false;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //* Drawer
        drawer: DancersDrawer(
          user: dancerDetails!,
        ),

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
