import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/home/data/repo_impl/job_repo_impl.dart';
import 'package:legwork/Features/home/domain/business_logic/post_job_business_logic.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';

class JobProvider extends ChangeNotifier {
  // Instance of job repo
  final JobRepoImpl jobRepo;
  bool isLoading = false;

  // constructor
  JobProvider({required this.jobRepo});

  // POST JOB METHOD
  Future<Either<String, JobEntity>> postJob({
    required String jobTitle,
    required String jobLocation,
    required List prefDanceStyles,
    required String pay,
    required String amtOfDancers,
    required String jobDuration,
    required String jobType,
    required String jobDescr,
    required bool status
  }) async {
    PostJobBusinessLogic postJobBusinessLogic =
        PostJobBusinessLogic(jobRepo: jobRepo);

    isLoading = true;
    notifyListeners();

    try {
      final result = await postJobBusinessLogic.postJobExecute(
        jobTitle: jobTitle,
        jobLocation: jobLocation,
        prefDanceStyles: prefDanceStyles,
        pay: pay,
        amtOfDancers: amtOfDancers,
        jobDuration: jobDuration,
        jobType: jobType,
        jobDescr: jobDescr,
        status: status
      );

      return result.fold(
        // handle fail
        (fail) => Left(fail),
        // handle success
        (jobEntity) => Right(jobEntity),
      );
    } catch (e) {
      debugPrint('error with job provider: $e');
      return Left(e.toString());
    }
  }

  // Local list of jobs
  Map<String, List<JobEntity>> allJobs = {};

  // FETCH JOB METHOD
  Future<Either<String, Map<String, List<JobEntity>>>> fetchJobs() async {
    JobRepoImpl jobRepo = JobRepoImpl();

    try {
      final result = await jobRepo.fetchJobs();

      return result.fold(
          // handle fail
          (fail) => Left(fail),

          // handle success
          (jobs) {
        allJobs = jobs;
        notifyListeners();
        return Right(allJobs);
      });
    } catch (e) {
      debugPrint('Error with fetch jobs provider: $e');
      return Left(e.toString());
    }
  }
}
