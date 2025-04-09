import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:legwork/features/home/data/models/job_model.dart';

class LocalJobService {
  static const String boxName = 'jobs_box';

  // * Save job to hive
  Future<Either<String, void>> saveJob(JobModel job) async {
    try {
      debugPrint('Saving job: ${job.toMap()}');
      final box = Hive.box<JobModel>(boxName);
      await box.put(job.jobId, job);
      debugPrint('Saving job: ${job.toMap()}');
      debugPrint('Job saved to hive! Current jobs: ${box.values.toList()}');
      debugPrint(
          'Current jobs in Hive: ${box.values.map((job) => job.toMap()).toList()}');
      return const Right(null);
    } catch (e) {
      debugPrint(
        'An unexpected error occured saving job to hive: ${e.toString()}',
      );
      return Left(
        'An unexpected error occured saving job to hive: ${e.toString()}',
      );
    }
  }

  // * Get jobs from hive
  Future<Either<String, List<JobModel>>> getJobs() async {
    try {
      final box = Hive.box<JobModel>(boxName);
      debugPrint('Job(s) gotten from hive!');
      return Right(box.values.toList());
    } catch (e) {
      debugPrint(
        'An unknown error occured while getting jobs from hive: ${e.toString()}',
      );
      return Left(
          'An unknown error occured while getting jobs from hive: ${e.toString()}');
    }
  }
}
