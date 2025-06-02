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
    return await remoteDataSource.applyForJob(application: applicationModel);
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

  // Function to get client details using client ID
  // This func is used to display the clients email, phone etc on the job appl screen
  @override
  Future<Either<String, Map<String, dynamic>>> getClientDetails({
    required String clientId,
  }) async {
    try {
      final clientDetails =
          await remoteDataSource.getClientDetails(clientId: clientId);
      return clientDetails.fold(
          // Handle fail
          (fail) => Left(fail),

          // Handle success
          (clientDetails) {
        return Right(clientDetails);
      });
    } catch (e) {
      debugPrint('An unknown error occured while fetching client details: $e');
      return Left('An unknown error occured while fetching client details: $e');
    }
  }

  // GET PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS (FROM FIRESTORE)
  @override
  Future<Either<String, List<Map<String, dynamic>>>>
      getPendingApplicationsWithJobs() async {
    try {
      return await remoteDataSource.getPendingApplicationsWithJobs();
    } catch (e) {
      debugPrint('Error with getPendingApplicationsWithJobs: $e');
      return Left(e.toString());
    }
  }

  // GET REJECTED APPLICATIONS WITH THEIR CORRESPONDING JOBS (FROM FIRESTORE)
  @override
  Future<Either<String, List<Map<String, dynamic>>>>
      getRejectedApplicationsWithJobs() async {
    try {
      return await remoteDataSource.getRejectedApplicationsWithJobs();
    } catch (e) {
      debugPrint('Error with getRejectedApplicationsWithJobs: $e');
      return Left(e.toString());
    }
  }

  // GET ACCEPTED APPLICATIONS WITH THEIR CORRESPONDING JOBS (FROM FIRESTORE)
  @override
  Future<Either<String, List<Map<String, dynamic>>>>
      getAcceptedApplicationsWithJobs() async {
    try {
      return await remoteDataSource.getAcceptedApplicationsWithJobs();
    } catch (e) {
      debugPrint('Error with getAcceptedApplicationsWithJobs: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> acceptApplication({
    required String applicationId,
  }) async {
    try {
      final result = await remoteDataSource.acceptApplication(
        applicationId: applicationId,
      );

      return result.fold(
        // handle fail
        (fail) => Left(fail),
        (_) => const Right(null),
      );
    } catch (e) {
      debugPrint('Error accepting application: ${e.toString()}');
      return Left('Error accepting application: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> rejectApplication({
    required String applicationId,
  }) async {
    try {
      final result = await remoteDataSource.rejectApplication(
        applicationId: applicationId,
      );

      return result.fold(
        // handle fail
        (fail) => Left(fail),
        (_) => const Right(null),
      );
    } catch (e) {
      debugPrint('Error rejecting application: ${e.toString()}');
      return Left('Error rejecting application: ${e.toString()}');
    }
  }
}
