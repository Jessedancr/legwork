import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/job_application/data/models/job_application_model.dart';

class JobApplicationRemoteDataSource {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // APPLY FOR JOB
  Future<Either<String, void>> applyForJob(
    JobApplicationModel application,
  ) async {
    try {
      // Get the currently logged-in user
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final uid = user.uid; // The dancer applying for the job

      // Retrieve the job details to get the clientId
      DocumentSnapshot jobSnapshot =
          await db.collection('jobs').doc(application.jobId).get();

      if (!jobSnapshot.exists) {
        return const Left('Job not found');
      }

      final String clientId = jobSnapshot['clientId']; // Get the client ID

      // Create a new application document
      final applicationData = application.toMap();
      applicationData['clientId'] = clientId; // Attach client ID

      // Add application to Firestore
      await db.collection('jobApplications').add(applicationData);

      return const Right(null);
    } catch (e) {
      return Left("Failed to apply for job: $e");
    }
  }
}
