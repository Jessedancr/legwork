import 'package:dartz/dartz.dart';
import 'package:legwork/Features/job_application/data/repo_impl/job_application_repo_impl.dart';
import 'package:legwork/Features/job_application/domain/entities/job_application_entity.dart';
import 'package:legwork/Features/job_application/domain/repo/job_application_repo.dart';

class GetJobApplicantsBusinessLogic {
  final JobApplicationRepoImpl jobApplicationRepo;

  GetJobApplicantsBusinessLogic({required this.jobApplicationRepo});
  Future<Either<String, List<JobApplicationEntity>>> getJobApplicationsExecute(
    String jobId,
  ) async {
    // todo: implement some business logic and validation rules here
    return jobApplicationRepo.getJobApplications(jobId);
  }
}
