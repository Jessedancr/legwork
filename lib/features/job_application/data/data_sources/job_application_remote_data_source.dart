import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/job_application/data/models/job_application_model.dart';
import 'package:legwork/Features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class JobApplicationRemoteDataSource {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late final NotificationRemoteDataSource notificationRemoteDataSource;

  JobApplicationRemoteDataSource() {
    notificationRemoteDataSource =
        NotificationRemoteDataSourceImpl(firebaseMessaging: firebaseMessaging);
  }

  // GET DANCER DEVICE TOKEN
  Future<String?> getDancerDeviceToken(String dancerId) async {
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

  // APPLY FOR JOB
  Future<Either<String, String>> applyForJob(
    JobApplicationModel application,
  ) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final uid = user.uid;

      // Fetch job details
      final jobSnapshot =
          await db.collection('jobs').doc(application.jobId).get();

      // If job does not exist
      if (!jobSnapshot.exists) return const Left('Job not found');

      // Gwt the client ID from the job document
      final String clientId = jobSnapshot['clientId'];

      // ✅ Check for duplicate application
      final duplicateCheck = await db
          .collection('jobApplications')
          .where('jobId', isEqualTo: application.jobId)
          .where('dancerId', isEqualTo: uid)
          .limit(1)
          .get();

      if (duplicateCheck.docs.isNotEmpty) {
        return const Left('You have already applied for this job');
      }

      // generate unique job ID
      final String applicationId = db.collection('jobApplications').doc().id;

      // Prepare updated application with correct IDs
      final updatedApplication = application.copyWith(
        dancerId: uid,
        clientId: clientId,
        applicationId: applicationId,
      );

      final applicationData = updatedApplication.toMap();

      // Save application with explicit applicationId field
      await db
          .collection('jobApplications')
          .doc(applicationId)
          .set(applicationData);

      return Right(applicationId);
    } catch (e) {
      return Left("Failed to apply for job: $e");
    }
  }

  // FETCH ALL JOB APPLICATIONS FOR A SPECIFIC JOB
  Future<Either<String, List<JobApplicationModel>>> getJobApplications(
    String jobId,
  ) async {
    try {
      // This query fetches all pending job applications for a specific job
      final snapshot = await db
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          // .where('applicationStatus', isEqualTo: 'pending')
          .get();

      final applications = snapshot.docs
          .map((doc) => JobApplicationModel.fromDocument(doc))
          .toList();

      return Right(applications);
    } catch (e) {
      return Left("Failed to fetch job applications: $e");
    }
  }

  // ACCEPT JOB APPLICATION
  Future<Either<String, void>> acceptApplication(String applicationId) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      // Get the document reference
      final docRef = db.collection('jobApplications').doc(applicationId);

      // Update the application status to 'accepted'
      await docRef.update({'applicationStatus': 'accepted'});

      // Delete the application after accepting
      // await docRef.delete();

      // Fetch dancer ID and device token
      final application = await docRef.get();
      final dancerId = application.data()?['dancerId'];
      final deviceToken = await getDancerDeviceToken(dancerId);

      // Send notification
      if (deviceToken != null) {
        await notificationRemoteDataSource.sendNotification(
          deviceToken: deviceToken,
          title: 'Application Accepted',
          body: 'Congratulations! Your application has been accepted.',
        );
      } else {
        debugPrint('Device token is null, notification not sent');
      }

      debugPrint('Application accepted  successfully');
      return const Right(null);
    } catch (e) {
      return Left("Failed to accept application: $e");
    }
  }

  // REJECT JOB APPLICATION
  Future<Either<String, void>> rejectApplication(String applicationId) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      // Update the application status to 'rejected'
      final docRef = db.collection('jobApplications').doc(applicationId);
      await docRef.update({'applicationStatus': 'rejected'});
      debugPrint('Application rejected successfully');

      // Fetch dancer ID and device token
      final application = await docRef.get();
      final dancerId = application.data()?['dancerId'];
      final deviceToken = await getDancerDeviceToken(dancerId);

      // Send notification
      if (deviceToken != null) {
        await notificationRemoteDataSource.sendNotification(
          deviceToken: deviceToken,
          title: 'Application Rejected',
          body: 'Unfortunately, your application has been rejected.',
        );
      }
      return const Right(null);
    } catch (e) {
      return Left("Failed to reject application: $e");
    }
  }

  // GET CLIENT DETAILS WITH CLIENT ID
  Future<Either<String, Map<String, dynamic>>> getClientDetails(
    String clientId,
  ) async {
    try {
      final clientDoc = await db.collection('clients').doc(clientId).get();

      if (!clientDoc.exists) return const Left('Client not found');

      return Right(clientDoc.data()!);
    } catch (e) {
      debugPrint('Failed to fetch client details: $e');
      return Left("Failed to fetch client details: $e");
    }
  }

  // GET PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS
  Future<Either<String, List<Map<String, dynamic>>>>
      getPendingApplicationsWithJobs() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final snapshot = await db
          .collection('jobApplications')
          .where('dancerId', isEqualTo: user.uid)
          .where('applicationStatus', isEqualTo: 'pending')
          .get();

      final applicationsWithJobs =
          await Future.wait(snapshot.docs.map((doc) async {
        final jobDoc = await db.collection('jobs').doc(doc['jobId']).get();

        // Skip if any required field is missing
        if (!doc.exists || !jobDoc.exists) {
          debugPrint('Missing required fields in Firestore document');
          return null;
        }

        return {
          'application': {
            ...doc.data(),
            'appliedAt': (doc['appliedAt'] as Timestamp).toDate(),
          },
          'job': {
            ...jobDoc.data()!,
            'createdAt': (jobDoc['createdAt'] as Timestamp).toDate(),
          },
        };
      }).toList());

      // Filter out null entries
      final validApplicationsWithJobs =
          applicationsWithJobs.where((item) => item != null).toList();

      return Right(validApplicationsWithJobs.cast<Map<String, dynamic>>());
    } catch (e) {
      return Left("Failed to fetch pending applications: $e");
    }
  }

  // GET REJECTED APPLICATIONS WITH THEIR CORRESPONDING JOBS
  Future<Either<String, List<Map<String, dynamic>>>>
      getRejectedApplicationsWithJobs() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final snapshot = await db
          .collection('jobApplications')
          .where('dancerId', isEqualTo: user.uid)
          .where('applicationStatus', isEqualTo: 'rejected')
          .get();

      final applicationsWithJobs =
          await Future.wait(snapshot.docs.map((doc) async {
        final jobDoc = await db.collection('jobs').doc(doc['jobId']).get();
        return {
          'application': doc.data(),
          'job': jobDoc.exists ? jobDoc.data() : null,
        };
      }).toList());

      return Right(applicationsWithJobs);
    } catch (e) {
      return Left("Failed to fetch rejected applications: $e");
    }
  }

  // GET ACCEPTED APPLICATIONS WITH THEIR CORRESPONDING JOBS
  Future<Either<String, List<Map<String, dynamic>>>>
      getAcceptedApplicationsWithJobs() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final snapshot = await db
          .collection('jobApplications')
          .where('dancerId', isEqualTo: user.uid)
          .where('applicationStatus', isEqualTo: 'accepted')
          .get();

      final applicationsWithJobs =
          await Future.wait(snapshot.docs.map((doc) async {
        final jobDoc = await db.collection('jobs').doc(doc['jobId']).get();
        return {
          'application': doc.data(),
          'job': jobDoc.exists ? jobDoc.data() : null,
        };
      }).toList());

      return Right(applicationsWithJobs);
    } catch (e) {
      return Left("Failed to fetch accepted applications: $e");
    }
  }

  // GET DANCER'S DETAILS WITH DANCERID
  Future<Either<String, Map<String, dynamic>>> getDancerDetails({
    required String dancerId,
  }) async {
    try {
      final dancerDoc = await db.collection('dancers').doc(dancerId).get();

      if (!dancerDoc.exists) return const Left('Dancer not found');

      return Right(dancerDoc.data()!);
    } catch (e) {
      debugPrint('Failed to fetch dancers details: $e');
      return Left("Failed to fetch dancers details: $e");
    }
  }
}
