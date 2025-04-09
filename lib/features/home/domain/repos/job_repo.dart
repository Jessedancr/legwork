import 'package:dartz/dartz.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';

/**
 * THIS CLASS INTERFACES BETWEEN THE DATA LAYER AND THE APP'S BUSINESS LOGIC
 * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 * CONVERTS THE JOB MODEL RETURNED BY THE DATA LAYER INTO A JOB ENTITY
 */

abstract class JobRepo {
  // POST JOBS
  Future<Either<String, JobEntity>> createJob({required JobEntity job});

  // FETCH JOBS
  Future<Either<String, Map<String, List<JobEntity>>>> fetchJobs();
}
