import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:legwork/Features/job_application/data/data_sources/job_application_remote_data_source.dart';

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

  final remoteDataSource = JobApplicationRemoteDataSource();

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
  // Used by client when viewing all applications to his job
  List<JobApplicationEntity> allApplications = [];

  // Local list of pending applications
  // Used by dancer when viewing all the jobs he has applied to
  List<JobApplicationEntity> pendingApplications = [];

  // Add this to your provider's properties
  Map<JobApplicationEntity, JobEntity> pendingAppsWithJobs = {};

  // Client details
  Map<String, dynamic>? clientDetails;

  // Dancer details
  Map<String, dynamic>? dancerDetails;

  // Boolean flag to track loading state
  bool isLoading = false;

  // GET CURRENT USER ID
  Future<Either<String, String>> getUserId() async {
    try {
      final userId = await remoteDataSource.getUserId();

      return userId;
    } catch (e) {
      debugPrint('Error with getUserId provider: ${e.toString()}');
      return Left('Error with getUserId provider: ${e.toString()}');
    }
  }

  /// APPLY FOR JOB
  Future<Either<String, String>> applyForJob(
    JobApplicationEntity application,
  ) async {
    // Instance of job application business logic
    final result =
        await applyForJobBusinessLogic.applyForJobExecute(application);
    return result.fold(
      // handle fail
      (fail) => Left(fail),

      // handle success
      (applicationId) => Right(applicationId),
    );
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
        (applications) async {
          allApplications = applications;

          isLoading = false;
          notifyListeners();
          return Right(allApplications);

          // Fetch dancer details for each application
          // for (var app in applications)  {
          //   final dancerResult = await getDancerDetails(dancerId: app.dancerId);
          //   dancerResult.fold(
          //     (error) => debugPrint('Failed to fetch dancer details: $error'),
          //     (dancerData) {
          //       app. = dancerData['firstName'] ?? 'Unknown Dancer';
          //     },
          //   );
          // }

          // allApplications = applications;

          // isLoading = false;
          // notifyListeners();
          // return Right(allApplications);
        },
      );
    } catch (e) {
      debugPrint('Error with getJobApplications provider: $e');
      return const Left('Error with getJobApplications provider');
    }
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

  /// GET DANCER DETAILS
  Future<Either<String, Map<String, dynamic>>> getDancerDetails({
    required String dancerId,
  }) async {
    try {
      final result =
          await jobApplicationRepo.getDancerDetails(dancerId: dancerId);

      return result.fold(
        // Handle fail
        (fail) => Left(fail),

        // handle success
        (data) {
          dancerDetails = data;
          debugPrint("Dancer data: ${data.toString()}");
          notifyListeners();
          return Right(data);
        },
      );
    } catch (e) {
      debugPrint('An unknown error occured with getDancerDetails provider: $e');
      return Left(
          'An unknown error occured with getDancerDetails provider: $e');
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
