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
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final uid = user.uid;

      // Fetch job details
      final jobSnapshot =
          await db.collection('jobs').doc(application.jobId).get();
      if (!jobSnapshot.exists) return const Left('Job not found');

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

      // ✅ Prepare updated application with correct IDs
      final updatedApplication = application.copyWith(
        dancerId: uid,
        clientId: clientId,
      );

      final applicationData = updatedApplication.toMap();

      // Save application
      await db.collection('jobApplications').add(applicationData);

      return const Right(null);
    } catch (e) {
      return Left("Failed to apply for job: $e");
    }
  }
}
