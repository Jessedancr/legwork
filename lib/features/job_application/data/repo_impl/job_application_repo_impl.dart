import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/home/data/models/job_model.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/job_application/data/data_sources/job_application_local_datasource.dart';
import 'package:legwork/Features/job_application/domain/repo/job_application_repo.dart';
import '../../domain/entities/job_application_entity.dart';
import '../data_sources/job_application_remote_data_source.dart';
import '../models/job_application_model.dart';

class JobApplicationRepoImpl implements JobApplicationRepo {
  // Instance of remote data source
  final remoteDataSource = JobApplicationRemoteDataSource();

  // Instance of local data source (HIVE)
  final localDataSource = JobApplicationLocalDataSource();

  // APPLY FOR JOB
  @override
  Future<Either<String, void>> applyForJob(
    JobApplicationEntity application,
  ) async {
    final applicationModel = JobApplicationModel(
      jobId: application.jobId,
      dancerId: application.dancerId,
      clientId: application.clientId,
      applicationId: application.applicationId,
      applicationStatus: application.applicationStatus,
      proposal: application.proposal,
      appliedAt: application.appliedAt,
    );

    // Save to local data storage
    await localDataSource.saveJobApplication(applicationModel);

    // Save to remote data storage
    return await remoteDataSource.applyForJob(applicationModel);
  }

  // GET APPLICATION
  @override
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications(
    String jobId,
  ) async {
    try {
      // Fetch from local data storage first then remote storage
      final localApplications = await localDataSource.getJobApplications();
      localApplications.fold(
        (fail) => Left(fail),
        (applications) {
          if (applications.isNotEmpty) {
            return Right(applications);
          }
          return const Left('No applications found in hive');
        },
      );
      final remoteApplications =
          await remoteDataSource.getJobApplications(jobId);

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

  // DELETE APPLICATION FROM HIVE
  @override
  Future<void> deleteAcceptedApplication(String applicationId) async {
    await localDataSource.deleteJobApplication(applicationId);
  }

  // Function to get client details using client ID
  // This func is used to display the clients email, phone etc on the job appl screen
  Future<Either<String, Map<String, dynamic>>> getClientDetails(
    String clientId,
  ) async {
    try {
      final clientDetails = await remoteDataSource.getClientDetails(clientId);
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

  // Function to get pending applications from hive
  Future<Either<String, List<JobApplicationEntity>>>
      getPendingApplications() async {
    try {
      final pendingApplications =
          await localDataSource.getPendingApplications();

      return pendingApplications.fold(
        // Handle fail
        (fail) => Left(fail),

        // Handle success
        (pending) {
          return Right(pending);
        },
      );
    } catch (e) {
      debugPrint(
        'Error with getPendingJobApplications method from job appl repo imp: $e',
      );
      return Left(e.toString());
    }
  }

  // GET CORRESPNDING PENDING JOBS USING JOBIDS FROM APPLICATIONS (FROM HIVE)
  Future<Either<String, Map<JobApplicationEntity, JobEntity>>>
      getPendingAppsWithJobs() async {
    try {
      final result = await localDataSource.getPendingApplicationsWithJobs();

      return result.fold(
        // handle fail
        (fail) {
          debugPrint(fail);
          return Left(fail);
        },

        // Handle success
        (result) {
          return Right(result);
        },
      );
    } catch (e) {
      debugPrint(
        'Unknown error occured with getPendingAppsWithJobs method: ${e.toString()}',
      );
      return Left(
        'Unknown error occured with getPendingAppsWithJobs method: ${e.toString()}',
      );
    }
  }

  // GET PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS (FROM FIRESTORE)
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
  Future<Either<String, List<Map<String, dynamic>>>>
      getAcceptedApplicationsWithJobs() async {
    try {
      return await remoteDataSource.getAcceptedApplicationsWithJobs();
    } catch (e) {
      debugPrint('Error with getAcceptedApplicationsWithJobs: $e');
      return Left(e.toString());
    }
  }
}
