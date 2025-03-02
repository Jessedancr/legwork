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
    required String jobType,
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
        'jobType': jobType,
        'createdAt': FieldValue.serverTimestamp(), // Timestamp
        'status': true,
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
    } on FirebaseAuthException catch (e) {
      debugPrint('Error fetching jobs from firestore: ${e.code}');
      return Left(e.toString());
    } catch (e) {
      debugPrint('Unknown error while fetching jobs from firestor: $e');
      return Left(e.toString());
    }
  }

  /**
   * * This method checks if the logged in user is a client or dancer
   * * If dancer then fetch all jobs from firebase
   * * If client fetch only jobs the client posted
   */
  Future<Either<String, Map<String, List<JobModel>>>> fetchJobs() async {
    // RETRIVE JOBS FROM
    try {
      // Get logged-in user ID
      final user = auth.currentUser;
      if (user == null) {
        return const Left("User not logged in");
      }

      final uid = user.uid;

      // query the dancer and clients collection at the same time
      final results = await Future.wait({
        db.collection('dancers').doc(uid).get(),
        db.collection('clients').doc(uid).get()
      });
      final dancersDoc = results[0];
      final clientsDoc = results[1];

      // Check if the document is in the dancers collection
      // If logged in user is dancer, return all jobs
      if (dancersDoc.exists) {
        final result = await db
            .collection('jobs')
            .orderBy('createdAt', descending: true)
            .get();
        List<JobModel> allJobs =
            result.docs.map((doc) => JobModel.fromDocument(doc)).toList();

        return Right({"allJobs": allJobs});
      } else if (clientsDoc.exists) {
        // If user is a client, fetch only jobs posted by logged in client
        final result = await db
            .collection('jobs')
            .where('clientId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

        List<JobModel> allClientJobs =
            result.docs.map((doc) => JobModel.fromDocument(doc)).toList();
        // Separate open and closed jobs
        List<JobModel> openJobs =
            allClientJobs.where((job) => job.status == true).toList();
        List<JobModel> closedJobs =
            allClientJobs.where((job) => job.status == false).toList();
        return Right({
          'openJobs': openJobs,
          'closedJobs': closedJobs,
        });
      } else {
        return const Left("Unknown user role");
      }
    } on FirebaseException catch (e) {
      debugPrint('Error fetching jobs from Firestore: ${e.code}');
      return Left(e.toString());
    } catch (e) {
      debugPrint('Unknown error while fetching jobs from Firestore: $e');
      return Left(e.toString());
    }
  }
}
