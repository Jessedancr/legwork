import 'package:dartz/dartz.dart';
import 'package:legwork/Features/job_application/domain/repo/job_application_repo.dart';
import '../../domain/entities/job_application_entity.dart';
import '../data_sources/job_application_remote_data_source.dart';
import '../models/job_application_model.dart';

class JobApplicationRepoImpl implements JobApplicationRepo {
  final JobApplicationRemoteDataSource remoteDataSource;

  JobApplicationRepoImpl({required this.remoteDataSource});

  @override
  Future<Either<String, void>> applyForJob(
      JobApplicationEntity application) async {
    final applicationModel = JobApplicationModel(
      jobId: application.jobId,
      dancerId: application.dancerId,
      clientId: application.clientId,
      applicationStatus: application.applicationStatus,
      proposal: application.proposal,
      appliedAt: application.appliedAt,
    );

    return await remoteDataSource.applyForJob(applicationModel);
  }

  @override
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications(
      String dancerId) {
    // TODO: implement getJobApplications
    throw UnimplementedError();
  }
}
