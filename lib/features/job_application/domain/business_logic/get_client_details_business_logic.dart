import 'package:dartz/dartz.dart';
import 'package:legwork/Features/job_application/data/repo_impl/job_application_repo_impl.dart';

class GetClientDetailsBusinessLogic {
  final JobApplicationRepoImpl jobApplicationRepo;

  GetClientDetailsBusinessLogic({required this.jobApplicationRepo});

  Future<Either<String, Map<String, dynamic>>> getClientDetails(
    String clientId,
  ) {
    // TODO: IMPLEMENT BUSINESS LOGIC TO GET CLIENT DETAILS
    return jobApplicationRepo.getClientDetails(clientId);
  }
}
