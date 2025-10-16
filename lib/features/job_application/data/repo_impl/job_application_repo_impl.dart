import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/job_application/data/data_sources/job_application_remote_data_source.dart';
import 'package:legwork/features/job_application/data/models/job_application_model.dart';
import 'package:legwork/features/job_application/domain/entities/job_application_entity.dart';
import 'package:legwork/features/job_application/domain/repo/job_application_repo.dart';

class JobApplicationRepoImpl implements JobApplicationRepo {
  // Instance of remote data source
  final remoteDataSource = JobApplicationRemoteDataSource();

  // APPLY FOR JOB
  @override
  Future<Either<String, JobApplicationEntity>> applyForJob({
    required JobApplicationEntity application,
  }) async {
    final applicationModel = JobApplicationModel(
      jobId: application.jobId,
      dancerId: application.dancerId,
      clientId: application.clientId,
      applicationId: application.applicationId,
      applicationStatus: application.applicationStatus,
      proposal: application.proposal,
      appliedAt: application.appliedAt,
    );

    // Save to remote data storage
    return await remoteDataSource.applyForJob(app: applicationModel);
  }

  // GET APPLICATION
  @override
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications({
    required String jobId,
  }) async {
    try {
      final remoteApplications =
          await remoteDataSource.getJobApplications(jobId: jobId);

      return remoteApplications.fold(
        // handle fail
        (fail) => left(fail),

        // handle success
        (jobApplications) {
          return Right(jobApplications);
        },
      );
    } catch (e) {
      debugPrint(
          'Error with getJobApplications method from job appl repo imp: $e');
      return Left(e.toString());
    }
  }

  // GET PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS (FROM FIRESTORE)
  @override
  Future<Either<String, List<Map<String, dynamic>>>>
      getApplicationsWithJobs() async {
    try {
      return await remoteDataSource.getApplicationsWithJobs();
    } catch (e) {
      debugPrint('Error with getPendingApplicationsWithJobs: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> acceptApplication({
    required String applicationId,
  }) async {
    try {
      final result = await remoteDataSource.acceptApplication(
        applicationId: applicationId,
      );

      return result.fold(
        // handle fail
        (fail) => Left(fail),
        (data) => Right(data),
      );
    } catch (e) {
      debugPrint('Error accepting application: ${e.toString()}');
      return Left('Error accepting application: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Map<String, dynamic>>> rejectApplication({
    required String applicationId,
  }) async {
    try {
      final result = await remoteDataSource.rejectApplication(
        applicationId: applicationId,
      );

      return result.fold(
        // handle fail
        (fail) => Left(fail),
        (data) => Right(data),
      );
    } catch (e) {
      debugPrint('Error rejecting application: ${e.toString()}');
      return Left('Error rejecting application: ${e.toString()}');
    }
  }
}
