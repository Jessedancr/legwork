import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:legwork/Features/job_application/domain/business_logic/apply_for_job.dart';
import '../../domain/entities/job_application_entity.dart';


class JobApplicationProvider extends ChangeNotifier {
  final ApplyForJob applyForJobUseCase;

  JobApplicationProvider({required this.applyForJobUseCase});

  Future<Either<String, void>> applyForJob(JobApplicationEntity application) async {
    final result = await applyForJobUseCase.applyForJobExecute(application);
    return result;
  }
}
