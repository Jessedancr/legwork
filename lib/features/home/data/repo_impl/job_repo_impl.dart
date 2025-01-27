import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/home/data/data_sources/home_remote_data_source.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/home/domain/repos/job_repo.dart';

/**
 * THIS CLASS IMPLEMENTS THE JOB REPO CLASS
 */

class JobRepoImpl implements JobRepo {
  final jobRemoteDataSource = JobService();

  @override
  Future<Either<String, JobEntity>> createJob({
    required String jobTitle,
    required String jobLocation,
    required List prefDanceStyles,
    required String pay,
    required String amtOfDancers,
    required String jobDuration,
    required String jobDescr,
  }) async {
    try {
      final result = await jobRemoteDataSource.createJob(
        jobTitle: jobTitle,
        jobLocation: jobLocation,
        prefDanceStyles: prefDanceStyles,
        pay: pay,
        amtOfDancers: amtOfDancers,
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
            jobDescr: jobDescr,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Job repo error: $e');
      return Left(e.toString());
    }
  }
}
