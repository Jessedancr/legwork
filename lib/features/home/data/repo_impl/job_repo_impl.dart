import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/home/data/data_sources/home_remote_data_source.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/home/domain/repos/job_repo.dart';

/**
 * THIS CLASS IMPLEMENTS THE JOB REPO CLASS
 */

class JobRepoImpl implements JobRepo {
  final jobService = JobService();

  @override
  Future<Either<String, JobEntity>> createJob({
    required String jobTitle,
    required String jobLocation,
    required List prefDanceStyles,
    required String pay,
    required String amtOfDancers,
    required String jobDuration,
    required String jobType,
    required String jobDescr,
    required bool status,
  }) async {
    try {
      final result = await jobService.createJob(
        jobTitle: jobTitle,
        jobLocation: jobLocation,
        prefDanceStyles: prefDanceStyles,
        pay: pay,
        amtOfDancers: amtOfDancers,
        jobType: jobType,
        jobDuration: jobDuration,
        jobDescr: jobDescr,
      );

      return result.fold(
        // handle fail
        (fail) => Left(fail.toString()),
        // handle success
        (jobEntity) => Right(
          JobEntity(
            jobTitle: jobTitle,
            jobLocation: jobLocation,
            prefDanceStyles: prefDanceStyles,
            pay: pay,
            amtOfDancers: amtOfDancers,
            jobDuration: jobDuration,
            jobType: jobType,
            jobDescr: jobDescr,
            status: status,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Job repo error: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<JobEntity>>> getJobs() async {
    try {
      final result = await jobService.getJobs();
      return result.fold(
        // handle fail
        (fail) => Left(fail),

        // handle success
        (jobs) => Right(
          jobs
              .map(
                (job) => JobEntity(
                  jobTitle: job.jobTitle,
                  jobLocation: job.jobLocation,
                  prefDanceStyles: job.prefDanceStyles,
                  pay: job.pay,
                  amtOfDancers: job.amtOfDancers,
                  jobDuration: job.jobDuration,
                  jobType: job.jobType,
                  jobDescr: job.jobDescr,
                  status: job.status,
                ),
              )
              .toList(),
        ),
      );
    } catch (e) {
      debugPrint('Error on getJobs method from JobRepoImpl: $e');
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, Map<String, List<JobEntity>>>> fetchJobs() async {
    try {
      final result = await jobService.fetchJobs();
      return result.fold(
          // handle fail
          (fail) => left(fail),

          // handle success
          (jobs) => Right(jobs));
    } catch (e) {
      debugPrint('Error on getJobs method from JobRepoImpl: $e');
      return Left(e.toString());
    }
  }
}
