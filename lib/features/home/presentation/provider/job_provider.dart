import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/home/data/repo_impl/job_repo_impl.dart';
import 'package:legwork/Features/home/domain/business_logic/post_job_business_logic.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';

class JobProvider extends ChangeNotifier {
  // Instance of job repo
  final JobRepoImpl jobRepo;

  bool isLoading = false;
  Map<String, List<JobEntity>> allJobs = {}; // Cached jobs

  // Constructor
  JobProvider({required this.jobRepo});

  // POST JOB METHOD
  Future<Either<String, JobEntity>> postJob({
    // required String jobTitle,
    // required String jobLocation,
    // required List prefDanceStyles,
    // required String pay,
    // required String amtOfDancers,
    // required String jobDuration,
    // required String jobType,
    // required String jobDescr,
    // required String jobId,
    // required String clientId,
    // required bool status,
    required JobEntity job,
  }) async {
    PostJobBusinessLogic postJobBusinessLogic =
        PostJobBusinessLogic(jobRepo: jobRepo);

    isLoading = true;
    notifyListeners();

    try {
      final result = await postJobBusinessLogic.postJobExecute(
          job: JobEntity(
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
      ));

      isLoading = false;
      notifyListeners();

      return result.fold(
        (fail) => Left(fail),
        (jobEntity) {
          clearCachedJobs(); // Clear cached jobs when a new job is posted
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

  // Method to clear cached jobs
  void clearCachedJobs() {
    allJobs.clear();
    notifyListeners();
  }

  // FETCH JOB METHOD
  Future<Either<String, Map<String, List<JobEntity>>>> fetchJobs() async {
    isLoading = true;
    // notifyListeners();

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
