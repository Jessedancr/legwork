import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:legwork/Features/job_application/data/models/job_application_model.dart';

class JobApplicationLocalDataSource {
  static const String boxName = 'job_applications_box';

  //* Save application to hive
  Future<Either<String, void>> saveJobApplication(
    JobApplicationModel application,
  ) async {
    try {
      final box = Hive.box<JobApplicationModel>(boxName);
      await box.put(application.applicationId, application);
      debugPrint('Job saved to hive!');
      return const Right(null);
    } catch (e) {
      return const Left('An unexpected error occured');
    }
  }

  // * Get applications from hive
  Future<Either<String, List<JobApplicationModel>>> getJobApplications() async {
    try {
      final box = Hive.box<JobApplicationModel>(boxName);
      // box.get(boxName);
      debugPrint('Job(s) gotten from hive!');
      return Right(box.values.toList());
    } catch (e) {
      debugPrint(
          'An unknown error occured while getting job applications from hive: $e');
      return Left(
          'An unknown error occured while getting job applications from hive: $e');
    }
  }

  // * Delete applications from hive
  Future<Either<String, void>> deleteJobApplication(
    String applicationId,
  ) async {
    try {
      final box = Hive.box<JobApplicationModel>(boxName);
      await box.delete(applicationId);
      debugPrint('Job deleted from hive!');
      return const Right(null);
    } catch (e) {
      debugPrint(
        'An unknown error occured while deleting job application from hive: $e',
      );
      return Left(
          'An unknown error occured while deleting job application from hive: $e');
    }
  }

  // * Get pending applications from hive
  Future<Either<String, List<JobApplicationModel>>>
      getPendingApplications() async {
    try {
      final box = Hive.box<JobApplicationModel>(boxName);
      List<JobApplicationModel> pendingApplications = box.values
          .where((app) => app.applicationStatus == 'pending')
          .toList();

      return Right(pendingApplications);
    } catch (e) {
      debugPrint('Error fetching pending applications from hive: $e');
      return Left('Erro fetching pending applications from hive: $e');
    }
  }

  // * On Accept
  // In this method, we'll change the status of the application to 'accepted'
  // So we can display it in the app
}
