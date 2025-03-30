import 'package:dartz/dartz.dart';
import 'package:legwork/Features/job_application/domain/repo/job_application_repo.dart';
import '../entities/job_application_entity.dart';

class ApplyForJobBusinessLogic {
  final JobApplicationRepo jobApplicationRepo;

  ApplyForJobBusinessLogic({required this.jobApplicationRepo});

  Future<Either<String, void>> applyForJobExecute(
    JobApplicationEntity application,
  ) {
    // todo: implement some business logic and validation rules here
    return jobApplicationRepo.applyForJob(application);
  }

  //* Delete accpeted applicatio from local storage (If the user chooses)
  // Future<void> deleteAcceptedApplication(String applicationId) async {
  //   await jobApplicationRepo.deleteAcceptedApplication(applicationId);
  // }
}
