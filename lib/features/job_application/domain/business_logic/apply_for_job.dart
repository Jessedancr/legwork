import 'package:dartz/dartz.dart';
import 'package:legwork/Features/job_application/domain/repo/job_application_repo.dart';
import '../entities/job_application_entity.dart';

class ApplyForJob {
  final JobApplicationRepo jobApplicationRepo;

  ApplyForJob(this.jobApplicationRepo);

  Future<Either<String, void>> applyForJobExecute(
      JobApplicationEntity application) {
    // todo: implement some business logic and validation rules here
    return jobApplicationRepo.applyForJob(application);
  }
}
