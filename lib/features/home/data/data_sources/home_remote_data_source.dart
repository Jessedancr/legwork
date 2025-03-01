import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/home/data/models/job_model.dart';

class JobService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // POST JOBS
  Future<Either<String, JobModel>> createJob({
    required String jobTitle,
    required String jobLocation,
    required List prefDanceStyles,
    required String pay,
    required String amtOfDancers,
    required String jobDuration,
    required String jobDescr,
  }) async {
    try {
      // Get currently logged in user
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      final String uid = user.uid;

      // generate uique job ID
      final String jobId = db.collection('jobs').doc().id;

      // store job date in firebase
      final jobData = {
        'jobTitle': jobTitle,
        'jobLocation': jobLocation,
        'prefDanceStyles': prefDanceStyles,
        'pay': pay,
        'amtOfDancers': amtOfDancers,
        'jobDuration': jobDuration,
        'jobDescr': jobDescr,
        'jobId': jobId,
        'clientId': uid,
        'createdAt': FieldValue.serverTimestamp(), // Timestamp
      };

      await db.collection('jobs').doc(jobId).set(jobData);

      DocumentSnapshot jobDoc = await db.collection('jobs').doc(jobId).get();
      final jobModel = JobModel.fromDocument(jobDoc);
      return Right(jobModel);
    } on FirebaseException catch (e) {
      debugPrint('Error posting job to firestore: ${e.code}');
      return left(e.code);
    } catch (e) {
      debugPrint('An unknown error occurred while posting job to firebase: $e');
      return Left(e.toString());
    }
  }

  // RETRIEVE JOBS FROM FIREBASE
  Future<Either<String, List<JobModel>>> getJobs() async {
    try {
      // Query the database to get jobs
      final result = await db
          .collection('jobs')
          .orderBy('createdAt', descending: true)
          .get();

      List<JobModel> jobs =
          result.docs.map((doc) => JobModel.fromDocument(doc)).toList();

      return Right(jobs);
    } on FirebaseException catch (e) {
      debugPrint('Error fetching jobs from firestore: ${e.code}');
      return Left(e.toString());
    } catch (e) {
      debugPrint('Unknown error while fetching jobs from firestor: $e');
      return Left(e.toString());
    }
  }
}
