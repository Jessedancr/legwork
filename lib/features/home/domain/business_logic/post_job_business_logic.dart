import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/home/data/repo_impl/job_repo_impl.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/home/domain/repos/job_repo.dart';

class PostJobBusinessLogic {
  final JobRepo jobRepo = JobRepoImpl();

  Future<Either<String, JobEntity>> postJobExecute({
    required JobEntity job,
  }) async {
    // TODO: Add some validations for posted jobs

    try {
      final jobModel = JobEntity(
        jobTitle: job.jobTitle,
        jobLocation: job.jobLocation,
        prefDanceStyles: job.prefDanceStyles,
        pay: job.pay,
        amtOfDancers: job.amtOfDancers,
        jobDuration: job.jobDuration,
        jobDescr: job.jobDescr,
        jobType: job.jobType,
        status: job.status,
        clientId: job.clientId,
        jobId: job.jobId,
        createdAt: job.createdAt,
      );
      final result = await jobRepo.createJob(job: jobModel);

      return result.fold(
        // Handle fail
        (fail) => Left(fail),
        // handle success
        (jobEntity) => Right(jobEntity),
      );
    } catch (e) {
      debugPrint('Post Job business logic error: $e');
      return Left(e.toString());
    }
  }
}
