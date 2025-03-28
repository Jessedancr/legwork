import 'package:dartz/dartz.dart';
import '../entities/job_application_entity.dart';

abstract class JobApplicationRepo {
  //* Save a new job application to firebase
  Future<Either<String, void>> applyForJob(JobApplicationEntity application);

  //* Fetch all job applications for a specific job
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications(
      String jobId);

  //* Delete accepted job application from local storage (If the user chooses)
  Future<void> deleteAcceptedApplication(String applicationId);

  // //* Fetch details of a specific job application
  // Future<Either<String, JobApplicationEntity>> getJobApplicationDetails(String applicationId);

  // //* Update the status of a job application
  // Future<Either<String, void>> updateApplicationStatus(String applicationId, String status);
}
