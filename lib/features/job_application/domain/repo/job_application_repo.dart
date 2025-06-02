import 'package:dartz/dartz.dart';
import 'package:legwork/features/job_application/domain/entities/job_application_entity.dart';

abstract class JobApplicationRepo {
  //* Save a new job application to firebase
  Future<Either<String, JobApplicationEntity>> applyForJob({
    required JobApplicationEntity application,
  });

  //* Fetch all job applications for a specific job
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications({
    required String jobId,
  });

  // * Accecpt job applicaiton
  Future<Either<String, void>> acceptApplication({
    required String applicationId,
  });

  // * Reject job application
  Future<Either<String, void>> rejectApplication({
    required String applicationId,
  });

  Future<Either<String, List<Map<String, dynamic>>>>
      getPendingApplicationsWithJobs();

  Future<Either<String, List<Map<String, dynamic>>>>
      getRejectedApplicationsWithJobs();

  Future<Either<String, List<Map<String, dynamic>>>>
      getAcceptedApplicationsWithJobs();

  Future<Either<String, Map<String, dynamic>>> getClientDetails({
    required String clientId,
  });
}
