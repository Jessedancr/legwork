import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/DataSources/auth_remote_data_source.dart';
import 'package:legwork/features/job_application/data/models/job_application_model.dart';
import 'package:legwork/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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
    required JobApplicationModel application,
  }) async {
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

      final updatedApplication = {
        ...application.toMap(),
        'dancerId': uid,
        'clientId': clientId,
        'applicationId': applicationId,
      };

      // Save application with explicit applicationId field
      await db
          .collection('jobApplications')
          .doc(applicationId)
          .set(updatedApplication);

      final jobApplicationDoc =
          await db.collection('jobApplications').doc(applicationId).get();
      final jobApplicationModel =
          JobApplicationModel.fromDocument(jobApplicationDoc);
      return Right(jobApplicationModel);

      // return Right(applicationId);
    } catch (e) {
      return Left("Failed to apply for job: $e");
    }
  }

  // * FETCH ALL JOB APPLICATIONS FOR A SPECIFIC JOB
  Future<Either<String, List<JobApplicationModel>>> getJobApplications({
    required String jobId,
  }) async {
    try {
      final snapshot = await db
          .collection('jobApplications')
          .where('jobId', isEqualTo: jobId)
          .get();

      final applications = snapshot.docs
          .map((doc) => JobApplicationModel.fromDocument(doc))
          .toList();

      return Right(applications);
    } catch (e) {
      return Left("Failed to fetch job applications: $e");
    }
  }

  // * ACCEPT JOB APPLICATION
  Future<Either<String, void>> acceptApplication({
    required String applicationId,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      // Get the document reference
      final applicationDocRef =
          db.collection('jobApplications').doc(applicationId);

      // Update the application status to 'accepted'
      await applicationDocRef.update({'applicationStatus': 'accepted'});

      // Fetch dancer ID and device token
      final applicationDoc = await applicationDocRef.get();
      final dancerId = applicationDoc.data()?['dancerId'];

      final userEntity =
          await _authRemoteDataSource.getUserDetails(uid: dancerId);
      userEntity.fold(
        (fail) => Left(fail),
        (user) async {
          // Extract device token from user entity object and send notification
          await notificationRemoteDataSource.sendNotification(
            deviceToken: user.deviceToken,
            title: 'Application Accepted',
            body: 'Congratulations! Your application has been accepted.',
          );
        },
      );

      // Delete the application after accepting
      // await docRef.delete();

      debugPrint('Application accepted  successfully');
      return const Right(null);
    } catch (e) {
      return Left("Failed to accept application: $e");
    }
  }

  // * REJECT JOB APPLICATION
  Future<Either<String, void>> rejectApplication({
    required String applicationId,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      // Update the application status to 'rejected'
      final applicationDocRef =
          db.collection('jobApplications').doc(applicationId);
      await applicationDocRef.update({'applicationStatus': 'rejected'});
      debugPrint('Application rejected successfully');

      // Fetch dancer ID and device token
      final applicationDoc = await applicationDocRef.get();
      final dancerId = applicationDoc.data()?['dancerId'];

      // Send notification
      final userEntity =
          await _authRemoteDataSource.getUserDetails(uid: dancerId);
      userEntity.fold(
        (fail) => Left(fail),
        (user) async {
          // Extract device token from user entity object and send notification
          await notificationRemoteDataSource.sendNotification(
            deviceToken: user.deviceToken,
            title: 'Application rejected',
            body: 'Unfortunately, your application has been rejected',
          );
        },
      );

      return const Right(null);
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
      getPendingApplicationsWithJobs() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      // Query the DB to get pending applications for logged in user
      final pendingApplicationsSnapshot = await db
          .collection('jobApplications')
          .where('dancerId', isEqualTo: user.uid)
          .where('applicationStatus', isEqualTo: 'pending')
          .get();

      final pendingAppsWithJobs = await Future.wait(
        pendingApplicationsSnapshot.docs.map(
          (applicationDoc) async {
            // Get the corresponding job for each application
            final jobDoc =
                await db.collection('jobs').doc(applicationDoc['jobId']).get();

            // Skip if any required field is missing
            if (!applicationDoc.exists || !jobDoc.exists) {
              debugPrint('Missing required fields in Firestore document');
              return null;
            }

            return {
              'application': applicationDoc.data(),
              'job': jobDoc.data()!,
            };
          },
        ).toList(),
      );

      return Right(pendingAppsWithJobs.cast<Map<String, dynamic>>());
    } catch (e) {
      return Left("Failed to fetch pending applications: $e");
    }
  }

  // * GET REJECTED APPLICATIONS WITH THEIR CORRESPONDING JOBS
  Future<Either<String, List<Map<String, dynamic>>>>
      getRejectedApplicationsWithJobs() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final rejectedApplicationsSnapshot = await db
          .collection('jobApplications')
          .where('dancerId', isEqualTo: user.uid)
          .where('applicationStatus', isEqualTo: 'rejected')
          .get();

      final rejectedAppsWithJobs = await Future.wait(
        rejectedApplicationsSnapshot.docs.map(
          (applicationDoc) async {
            // Get the corresponding job for each application
            final jobDoc =
                await db.collection('jobs').doc(applicationDoc['jobId']).get();
            return {
              'application': applicationDoc.data(),
              'job': jobDoc.exists ? jobDoc.data() : null,
            };
          },
        ).toList(),
      );

      return Right(rejectedAppsWithJobs);
    } catch (e) {
      return Left("Failed to fetch rejected applications: $e");
    }
  }

  // * GET ACCEPTED APPLICATIONS WITH THEIR CORRESPONDING JOBS
  Future<Either<String, List<Map<String, dynamic>>>>
      getAcceptedApplicationsWithJobs() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final acceptedApplicationsSanpshot = await db
          .collection('jobApplications')
          .where('dancerId', isEqualTo: user.uid)
          .where('applicationStatus', isEqualTo: 'accepted')
          .get();

      final acceptedAppsWithJobs = await Future.wait(
        acceptedApplicationsSanpshot.docs.map(
          (applicationDoc) async {
            final jobDoc =
                await db.collection('jobs').doc(applicationDoc['jobId']).get();
            return {
              'application': applicationDoc.data(),
              'job': jobDoc.exists ? jobDoc.data() : null,
            };
          },
        ).toList(),
      );

      return Right(acceptedAppsWithJobs);
    } catch (e) {
      return Left("Failed to fetch accepted applications: $e");
    }
  }
}
