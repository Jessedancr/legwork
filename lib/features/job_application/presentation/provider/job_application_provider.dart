import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:legwork/Features/job_application/data/repo_impl/job_application_repo_impl.dart';
import 'package:legwork/Features/job_application/domain/business_logic/apply_for_job.dart';
import '../../domain/entities/job_application_entity.dart';

class JobApplicationProvider extends ChangeNotifier {
  // Instance of job application repo
  final JobApplicationRepoImpl jobApplicationRepo;

  // Pass it to constructor
  JobApplicationProvider({required this.jobApplicationRepo});

  Future<Either<String, void>> applyForJob(
    JobApplicationEntity application,
  ) async {
    // Instance of job application business logic
    ApplyForJobBusinessLogic applyForJobBusinessLogic =
        ApplyForJobBusinessLogic(jobApplicationRepo: jobApplicationRepo);
    final result =
        await applyForJobBusinessLogic.applyForJobExecute(application);
    return result;
  }
}
