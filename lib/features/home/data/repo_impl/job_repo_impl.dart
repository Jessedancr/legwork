import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/home/data/data_sources/home_local_data_source.dart';
import 'package:legwork/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:legwork/features/home/data/models/job_model.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/home/domain/repos/job_repo.dart';

/**
 * THIS CLASS IMPLEMENTS THE JOB REPO CLASS
 */

class JobRepoImpl implements JobRepo {
  // Instance of remote data source
  final jobService = JobService();

  // Instance of local data source (Hive)
  final localJobService = LocalJobService();

  //* FUNCTION TO CREATE JOB
  @override
  Future<Either<String, JobEntity>> createJob({
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
    try {
      final jobModel = JobModel(
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

      final result = await jobService.createJob(
        job: JobModel(
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
        ),
      );

      // Save to local data storgae
      await localJobService.saveJob(jobModel);

      return result.fold(
        // handle fail
        (fail) => Left(fail.toString()),
        // handle success
        (jobEntity) => Right(
          JobEntity(
            jobTitle: job.jobTitle,
            jobLocation: job.jobLocation,
            prefDanceStyles: job.prefDanceStyles,
            pay: job.pay,
            amtOfDancers: job.amtOfDancers,
            jobDuration: job.jobDuration,
            jobType: job.jobType,
            jobDescr: job.jobDescr,
            clientId: job.clientId,
            jobId: job.jobId,
            status: job.status,
            createdAt: job.createdAt,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Job repo error: $e');
      return Left(e.toString());
    }
  }

  // * FUNCTION TO GET JOBS
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
