import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/home/data/repo_impl/job_repo_impl.dart';
import 'package:legwork/features/home/domain/business_logic/post_job_business_logic.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/home/domain/repos/job_repo.dart';

class JobProvider extends ChangeNotifier {
  // Instance of job repo
  final JobRepo jobRepo = JobRepoImpl();

  PostJobBusinessLogic postJobBusinessLogic = PostJobBusinessLogic();

  bool isLoading = false;
  Map<String, List<JobEntity>> allJobs = {}; // Cached jobs

  // POST JOB METHOD
  Future<Either<String, JobEntity>> postJob({
    required JobEntity job,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final jobEntity = JobEntity(
        jobTitle: job.jobTitle,
        jobLocation: job.jobLocation,
        prefDanceStyles: job.prefDanceStyles,
        pay: job.pay,
        amtOfDancers: job.amtOfDancers,
        jobDuration: job.jobDuration,
        jobDescr: job.jobDescr,
        jobType: job.jobType,
        jobId: job.jobId,
        clientId: job.clientId,
        status: job.status,
        createdAt: job.createdAt,
      );
      final result = await postJobBusinessLogic.postJobExecute(job: jobEntity);

      isLoading = false;
      notifyListeners();

      return result.fold(
        (fail) => Left(fail),
        (jobEntity) {
          allJobs.clear();
          return Right(jobEntity);
        },
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error with job provider: $e');
      return Left(e.toString());
    }
  }

  // FETCH JOB METHOD
  Future<Either<String, Map<String, List<JobEntity>>>> fetchJobs() async {
    isLoading = true;

    try {
      final result = await jobRepo.fetchJobs();

      return result.fold(
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },
        (jobs) {
          allJobs = jobs;
          isLoading = false;
          notifyListeners();
          return Right(allJobs);
        },
      );
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Error with fetch jobs provider: $e');
      return Left(e.toString());
    }
  }
}
