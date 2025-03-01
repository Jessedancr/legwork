import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/home/domain/repos/job_repo.dart';

class PostJobBusinessLogic {
  final JobRepo jobRepo;

  // constructor
  PostJobBusinessLogic({required this.jobRepo});

  Future<Either<String, JobEntity>> postJobExecute({
    required String jobTitle,
    required String jobLocation,
    required List prefDanceStyles,
    required String pay,
    required String amtOfDancers,
    required String jobDuration,
    required String jobDescr,
  }) async {
    // TODO: Add some validations for posted jobs

    try {
      final result = await jobRepo.createJob(
        jobTitle: jobTitle,
        jobLocation: jobLocation,
        prefDanceStyles: prefDanceStyles,
        pay: pay,
        amtOfDancers: amtOfDancers,
        jobDuration: jobDuration,
        jobDescr: jobDescr,
      );

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
