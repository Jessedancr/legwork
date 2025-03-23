import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/job_application/domain/repo/job_application_repo.dart';
import '../../domain/entities/job_application_entity.dart';
import '../data_sources/job_application_remote_data_source.dart';
import '../models/job_application_model.dart';

class JobApplicationRepoImpl implements JobApplicationRepo {
  // Instance of remote data source
  final remoteDataSource = JobApplicationRemoteDataSource();

  // Function to apply for job
  @override
  Future<Either<String, void>> applyForJob(
      JobApplicationEntity application) async {
    final applicationModel = JobApplicationModel(
      jobId: application.jobId,
      dancerId: application.dancerId,
      clientId: application.clientId,
      applicationId: application.applicationId,
      applicationStatus: application.applicationStatus,
      proposal: application.proposal,
      appliedAt: application.appliedAt,

    );

    return await remoteDataSource.applyForJob(applicationModel);
  }

  @override
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications(
    String jobId,
  ) async {
    try {
      final result = await remoteDataSource.getJobApplications(jobId);

      return result.fold(
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
}
