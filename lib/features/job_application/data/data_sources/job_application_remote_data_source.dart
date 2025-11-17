import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/Data/DataSources/auth_remote_data_source.dart';
import 'package:legwork/features/job_application/data/models/job_application_model.dart';
import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:legwork/features/notifications/domain/entities/notif_entity.dart';

class JobApplicationRemoteDataSource {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final NotificationRemoteDataSource notificationRemoteDataSource =
      NotificationRemoteDataSourceImpl();
  final AuthRemoteDataSource _authRemoteDataSource = AuthRemoteDataSourceImpl();

  // GET DANCER DEVICE TOKEN
  Future<String?> getDancerDeviceToken({required String dancerId}) async {
    try {
      final dancerDoc = await db.collection('dancers').doc(dancerId).get();
      if (dancerDoc.exists) {
        return dancerDoc.data()?['deviceToken'];
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching dancer device token: $e');
      return null;
    }
  }

  // GET CURRENTLY LOGGED IN USER
  Future<Either<String, String>> getUserId() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return const Left('user not found');
      }
      user.uid;
      return Right(user.uid);
    } catch (e) {
      debugPrint('failed to get logged in user\'s ID: ${e.toString()}');
      return Left('failed to get logged in user\'s ID: ${e.toString()}');
    }
  }

  // * APPLY FOR JOB
  Future<Either<String, JobApplicationModel>> applyForJob({
    required JobApplicationModel app,
  }) async {
    try {
      final jobId = app.jobId;

      final res = await apiClient.post(
        endpoint: 'job-applications/$jobId/apply-for-job',
        body: app.toMap(),
      );

      if (res.statusCode != 201) {
        final resBody = jsonDecode(res.body);
        final message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }
      final Map<String, dynamic> resBody = jsonDecode(res.body);
      final Map<String, dynamic> applicationDoc = resBody['application'];
      final String applicationId = applicationDoc['_id'];
      final String clientId = applicationDoc['clientId'];

      // * Send notification
      final clientEntity =
          await _authRemoteDataSource.getUserDetails(uid: clientId);

      clientEntity.fold(
        (fail) => Left(fail),
        (user) async {
          NotifEntity notif = NotifEntity(
            deviceToken: user.deviceToken,
            body: 'You have received a new application',
            title: 'New Job Application!',
            channelId: NotifChannelId.applications_channel.name,
          );
          await notificationRemoteDataSource.sendNotification(notif: notif);
        },
      );

      final applicationModel = JobApplicationModel.fromDoc({
        ...applicationDoc,
        app.applicationId: applicationId,
        app.clientId: clientId,
      });
      return Right(applicationModel);
    } catch (e) {
      return Left("Failed to apply for job: $e");
    }
  }

  // * FETCH ALL JOB APPLICATIONS FOR A SPECIFIC JOB
  Future<Either<String, List<JobApplicationModel>>> getJobApplications({
    required String jobId,
  }) async {
    try {
      final res = await apiClient.get(
        endpoint: 'job-applications/$jobId/applications',
      );

      if (res.statusCode != 200) {
        final Map<String, dynamic> resBody = jsonDecode(res.body);
        final String message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }
      final Map<String, dynamic> resBody = jsonDecode(res.body);
      final List applications = resBody['applications'];
      final jobApplications =
          applications.map((app) => JobApplicationModel.fromDoc(app)).toList();

      return Right(jobApplications);
    } catch (e) {
      return Left("Failed to fetch job applications: $e");
    }
  }

  // * ACCEPT JOB APPLICATION
  Future<Either<String, Map<String, dynamic>>> acceptApplication({
    required String applicationId,
  }) async {
    try {
      final res = await apiClient.patch(
        endpoint: 'job-applications/$applicationId/accept-app',
        body: {
          'applicationStatus': 'accepted',
        },
      );

      if (res.statusCode != 200) {
        final Map<String, dynamic> resBody = jsonDecode(res.body);
        final String message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }
      final Map<String, dynamic> resBody = jsonDecode(res.body);
      final Map<String, dynamic> app = resBody['app'];
      final String message = resBody['message'];
      final String dancerId = app['dancerId'];
      final userEntity =
          await _authRemoteDataSource.getUserDetails(uid: dancerId);
      userEntity.fold(
        (fail) => Left(fail),
        (user) async {
          NotifEntity notif = NotifEntity(
            deviceToken: user.deviceToken,
            body: 'Sharp guy! your application has been accepted',
            title: 'Application Accepted',
            channelId: NotifChannelId.applications_channel.name,
          );
          await notificationRemoteDataSource.sendNotification(notif: notif);
        },
      );

      // Delete the application after accepting
      // await docRef.delete();
      return Right({'message': message, 'application': app});
    } catch (e) {
      return Left("Failed to accept application: $e");
    }
  }

  // * REJECT JOB APPLICATION
  Future<Either<String, Map<String, dynamic>>> rejectApplication({
    required String applicationId,
  }) async {
    try {
      final res = await apiClient.patch(
        endpoint: 'job-applications/$applicationId/reject-app',
        body: {
          'applicationStatus': 'rejected',
        },
      );

      if (res.statusCode != 200) {
        final Map<String, dynamic> resBody = jsonDecode(res.body);
        final String message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }
      final Map<String, dynamic> resBody = jsonDecode(res.body);
      final Map<String, dynamic> app = resBody['app'];
      final String message = resBody['message'];
      final String dancerId = app['dancerId'];

      // Send notification
      final userEntity =
          await _authRemoteDataSource.getUserDetails(uid: dancerId);
      userEntity.fold(
        (fail) => Left(fail),
        (user) async {
          NotifEntity notif = NotifEntity(
            deviceToken: user.deviceToken,
            body: 'Unfortunately, your application has been rejected',
            title: 'Application Rejected',
            channelId: NotifChannelId.applications_channel.name,
          );
          await notificationRemoteDataSource.sendNotification(notif: notif);
        },
      );

      return Right({'message': message, 'application': app});
    } catch (e) {
      return Left("Failed to reject application: $e");
    }
  }

  // * GET CLIENT DETAILS WITH CLIENT ID
  Future<Either<String, Map<String, dynamic>>> getClientDetails({
    required String clientId,
  }) async {
    try {
      final clientDoc = await db.collection('clients').doc(clientId).get();

      if (!clientDoc.exists) return const Left('Client not found');

      return Right(clientDoc.data()!);
    } catch (e) {
      debugPrint('Failed to fetch client details: $e');
      return Left("Failed to fetch client details: $e");
    }
  }

  // * GET PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS
  Future<Either<String, List<Map<String, dynamic>>>>
      getApplicationsWithJobs() async {
    try {
      final res = await apiClient.get(
        endpoint: 'job-applications/get-dancer-applications',
      );
      if (res.statusCode != 200) {
        final Map<String, dynamic> resBody = jsonDecode(res.body);
        final String message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }
      final Map<String, dynamic> resBody = jsonDecode(res.body);
      final appsWithJobs = resBody['appsWithJobs'];

      final modApps = appsWithJobs.cast<Map<String, dynamic>>();
      return Right(modApps);
    } catch (e) {
      return Left("Failed to fetch pending applications: $e");
    }
  }
}
