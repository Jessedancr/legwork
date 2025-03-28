import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:legwork/Features/job_application/data/repo_impl/job_application_repo_impl.dart';
import 'package:legwork/Features/job_application/domain/business_logic/apply_for_job_business_logic.dart';
import 'package:legwork/Features/job_application/domain/business_logic/get_client_details_business_logic.dart';
import 'package:legwork/Features/job_application/domain/business_logic/get_job_applicants_business_logic.dart';
import '../../domain/entities/job_application_entity.dart';

class JobApplicationProvider extends ChangeNotifier {
  // Instance of job application repo
  final JobApplicationRepoImpl jobApplicationRepo;

  late ApplyForJobBusinessLogic applyForJobBusinessLogic;

  late GetJobApplicantsBusinessLogic getJobApplicantsBusinessLogic;

  late GetClientDetailsBusinessLogic getClientDetailsBusinessLogic;

  // Pass it to constructor
  JobApplicationProvider({
    required this.jobApplicationRepo,
    required this.getJobApplicantsBusinessLogic,
  }) {
    applyForJobBusinessLogic =
        ApplyForJobBusinessLogic(jobApplicationRepo: jobApplicationRepo);
    getClientDetailsBusinessLogic =
        GetClientDetailsBusinessLogic(jobApplicationRepo: jobApplicationRepo);
  }

  // Local list of job applications
  List<JobApplicationEntity> allApplications = [];

  bool isLoading = false;

  // Client details
  Map<String, dynamic>? clientDetails;

  /// APPLY FOR JOB
  Future<Either<String, void>> applyForJob(
    JobApplicationEntity application,
  ) async {
    // Instance of job application business logic
    final result =
        await applyForJobBusinessLogic.applyForJobExecute(application);
    return result;
  }

  /// FETCH JOB APPLICATIONS
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications(
    String jobId,
  ) async {
    try {
      isLoading = true;
      // notifyListeners();

      final result =
          await getJobApplicantsBusinessLogic.getJobApplicationsExecute(jobId);
      // isLoading = false;
      // notifyListeners();

      return result.fold(
        // handle failure
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left('Error with get job applications provider: $fail');
        },

        // hancle success
        (applications) {
          allApplications = applications;

          isLoading = false;
          notifyListeners();
          return Right(allApplications);
        },
      );
    } catch (e) {
      debugPrint('Error with getJobApplications provider: $e');
      return const Left('Error with getJobApplications provider');
    }
  }

  /// DELETE ACCEPTED JOB APPLICATION FROM LOCAL STORAGE (IF THE USER CHOOSES)
  Future<void> deleteAcceptedApplication(String applicationId) async {
    await applyForJobBusinessLogic.deleteAcceptedApplication(applicationId);
  }

  /// FETCH CLIENT DETAILS
  Future<Either<String, Map<String, dynamic>>> getClientDetails(
    String clientId,
  ) async {
    try {
      final result =
          await getClientDetailsBusinessLogic.getClientDetails(clientId);

      return result.fold(
          // handle fail
          (fail) => Left(fail),

          // handle success
          (data) {
        clientDetails = data;
        debugPrint("Client data: ${data.toString()}");
        notifyListeners();
        return Right(data);
      });
    } catch (e) {
      debugPrint('An unknown error occured with getClientDetails provider: $e');
      return Left(
          'An unknown error occured with getClientDetails provider: $e');
    }
  }
}
