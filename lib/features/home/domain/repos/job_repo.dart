import 'package:dartz/dartz.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';

/**
 * THIS CLASS INTERFACES BETWEEN THE DATA LAYER AND THE APP'S BUSINESS LOGIC
 * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 * CONVERTS THE JOB MODEL RETURNED BY THE DATA LAYER INTO A JOB ENTITY
 */

abstract class JobRepo {
  // POST JOBS
  Future<Either<String, JobEntity>> createJob({
    required String jobTitle,
    required String jobLocation,
    required List prefDanceStyles,
    required String pay,
    required String amtOfDancers,
    required String jobDuration,
    required String jobType,
    required String jobDescr,
    required String jobId,
    required String clientId,
    required bool status,
  });

  // // GET JOBS
  // Future<Either<String, List<JobEntity>>> getJobs();

  // FETCH JOBS
  Future<Either<String, Map<String, List<JobEntity>>>> fetchJobs();
}
