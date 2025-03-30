import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/job_application/data/data_sources/job_application_local_datasource.dart';
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

  late JobApplicationLocalDataSource jobApplicationLocalDataSource;

  // Pass it to constructor
  JobApplicationProvider({
    required this.jobApplicationRepo,
    required this.getJobApplicantsBusinessLogic,
    // required this.jobApplicationLocalDataSource,
  }) {
    applyForJobBusinessLogic =
        ApplyForJobBusinessLogic(jobApplicationRepo: jobApplicationRepo);
    getClientDetailsBusinessLogic =
        GetClientDetailsBusinessLogic(jobApplicationRepo: jobApplicationRepo);
  }

  // Local list of job applications
  // Used by client when viewing all applications to his job
  List<JobApplicationEntity> allApplications = [];

  // Local list of pending applications
  // Used by dancer when viewing all the jobs he has applied to
  List<JobApplicationEntity> pendingApplications = [];

  // Add this to your provider's properties
  Map<JobApplicationEntity, JobEntity> pendingAppsWithJobs = {};

  // Client details
  Map<String, dynamic>? clientDetails;

  // Boolean flag to track loading state
  bool isLoading = false;

  /// APPLY FOR JOB
  Future<Either<String, void>> applyForJob(
    JobApplicationEntity application,
  ) async {
    // Instance of job application business logic
    final result =
        await applyForJobBusinessLogic.applyForJobExecute(application);
    return result;
  }

  /// FETCH JOB APPLICATIONS FROM BOTH LOCAL AND REMOTE DB
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications(
    String jobId,
  ) async {
    try {
      isLoading = true;

      final result =
          await getJobApplicantsBusinessLogic.getJobApplicationsExecute(jobId);

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
  // Future<void> deleteAcceptedApplication(String applicationId) async {
  //   await applyForJobBusinessLogic.deleteAcceptedApplication(applicationId);
  // }

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

  /// FETCH PENDING APPLICATIONS FROM HIVE
  Future<Either<String, List<JobApplicationEntity>>>
      getPendingApplications() async {
    try {
      isLoading = true;

      final pending = await jobApplicationRepo.getPendingApplications();

      return pending.fold(
        // Handle fail
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(
            'Error with getPendingApplications provider: $fail',
          );
        },

        // Handle success
        (pending) async {
          pendingApplications = pending;
          debugPrint(pendingApplications.toString());
          isLoading = false;
          notifyListeners();

          return Right(pendingApplications);
        },
      );
    } catch (e) {
      debugPrint(
          'An unknown Error occured with getPendingApplications provider: $e');
      return const Left(
          'An unknown Error occured with getPendingApplications provider');
    }
  }

  /// FETCH PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS FROM HIVE
  Future<Either<String, Map<JobApplicationEntity, JobEntity>>>
      getPendingAppsWithJobs() async {
    try {
      isLoading = true;
      // notifyListeners();

      final result = await jobApplicationRepo.getPendingAppsWithJobs();

      return result.fold(
        // Handle failure
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },
        // Handle success
        (appsWithJobs) {
          pendingAppsWithJobs = appsWithJobs;
          isLoading = false;
          notifyListeners();
          return Right(pendingAppsWithJobs);
        },
      );
    } catch (e) {
      debugPrint('Error with getPendingAppsWithJobs provider: $e');
      isLoading = false;
      notifyListeners();
      return Left('Error with getPendingAppsWithJobs provider: $e');
    }
  }

  /// FETCH PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS FROM FIRESTORE
  Future<Either<String, List<Map<String, dynamic>>>>
      getPendingApplicationsWithJobs() async {
    try {
      isLoading = true;
      // notifyListeners();

      final result = await jobApplicationRepo.getPendingApplicationsWithJobs();

      return result.fold(
        // Handle failure
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },
        // Handle success
        (pendingAppsWithJobsList) {
          // Update the map with fetched data
          pendingAppsWithJobs = {
            for (var item in pendingAppsWithJobsList)
              JobApplicationEntity.fromMap(item['application']):
                  JobEntity.fromMap(item['job']),
          };

          isLoading = false;
          notifyListeners();
          return Right(pendingAppsWithJobsList);
        },
      );
    } catch (e) {
      debugPrint('Error with getPendingApplicationsWithJobs provider: $e');
      isLoading = false;
      notifyListeners();
      return Left('Error with getPendingApplicationsWithJobs provider: $e');
    }
  }

  /// FETCH REJECTED APPLICATIONS WITH THEIR CORRESPONDING JOBS FROM FIRESTORE
  Future<Either<String, List<Map<String, dynamic>>>>
      getRejectedApplicationsWithJobs() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await jobApplicationRepo.getRejectedApplicationsWithJobs();

      return result.fold(
        // Handle failure
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },
        // Handle success
        (rejectedAppsWithJobs) {
          isLoading = false;
          notifyListeners();
          return Right(rejectedAppsWithJobs);
        },
      );
    } catch (e) {
      debugPrint('Error with getRejectedApplicationsWithJobs provider: $e');
      isLoading = false;
      notifyListeners();
      return Left('Error with getRejectedApplicationsWithJobs provider: $e');
    }
  }

  /// FETCH ACCEPTED APPLICATIONS WITH THEIR CORRESPONDING JOBS FROM FIRESTORE
  Future<Either<String, List<Map<String, dynamic>>>>
      getAcceptedApplicationsWithJobs() async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await jobApplicationRepo.getAcceptedApplicationsWithJobs();

      return result.fold(
        // Handle failure
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },
        // Handle success
        (acceptedAppsWithJobs) {
          isLoading = false;
          notifyListeners();
          return Right(acceptedAppsWithJobs);
        },
      );
    } catch (e) {
      debugPrint('Error with getAcceptedApplicationsWithJobs provider: $e');
      isLoading = false;
      notifyListeners();
      return Left('Error with getAcceptedApplicationsWithJobs provider: $e');
    }
  }
}
