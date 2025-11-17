import 'package:flutter/material.dart';
import 'package:legwork/core/Constants/helpers.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';
import 'package:legwork/features/notifications/presentation/provider/notif_provider.dart';
import 'package:legwork/features/notifications/presentation/screens/job_application_notif_screen.dart';
import 'package:legwork/features/notifications/presentation/screens/jobs_for_you_notif_screen.dart';
import 'package:legwork/features/notifications/presentation/screens/payment_notif_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // * APPBAR
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Notifications',
            style: context.heading2Xs?.copyWith(
              color: context.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: context.colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'applications'),
              Tab(text: 'Payments'),
              Tab(text: 'Jobs for you')
            ],
          ),
        ),

        // * BODY
        body: const TabBarView(
          children: [
            JobApplicationNotifScreen(),
            PaymentNotifScreen(),
            JobsForYouNotifScreen()
          ],
        ),
      ),
    );
  }
}
