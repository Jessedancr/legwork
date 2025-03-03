import 'package:dartz/dartz.dart';
import '../entities/job_application_entity.dart';

abstract class JobApplicationRepo {
  //? Save a new job application to firebase
  Future<Either<String, void>> applyForJob(JobApplicationEntity application);

  //? retrieves all applications a dancer has made
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications(String dancerId);
}
