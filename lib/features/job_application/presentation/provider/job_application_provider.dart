import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:legwork/features/auth/Data/RepoImpl/auth_repo_impl.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/home/data/models/job_model.dart';
import 'package:legwork/features/home/domain/entities/job_entity.dart';
import 'package:legwork/features/job_application/data/data_sources/job_application_remote_data_source.dart';
import 'package:legwork/features/job_application/data/models/job_application_model.dart';

import 'package:legwork/features/job_application/data/repo_impl/job_application_repo_impl.dart';
import 'package:legwork/features/job_application/domain/entities/job_application_entity.dart';

class JobApplicationProvider extends ChangeNotifier {
  // Instance of job application repo
  final JobApplicationRepoImpl jobApplicationRepo = JobApplicationRepoImpl();

  final remoteDataSource = JobApplicationRemoteDataSource();
  final authrepo = AuthRepoImpl();

  // Local list of job applications
  // Used by client when viewing all applications to his job
  List<JobApplicationEntity> allApplications = [];

  Map<JobApplicationEntity, JobEntity> pendingAppsWithJobs = {};
  Map<JobApplicationEntity, JobEntity> acceptedAppsWithJobs = {};
  Map<JobApplicationEntity, JobEntity> rejectedAppsWithJobs = {};

  // Client details
  UserEntity? clientDetails;
  UserEntity? _dancer;

  // Getter to retrieve the currently logged in user
  UserEntity? get dancer => _dancer;

  // Dancer details
  Map<String, dynamic>? dancerDetails;

  // Boolean flag to track loading state
  bool isLoading = false;

 

  Future<Either<String, UserEntity>> getUserDetails({
    required String uid,
    bool forceRefresh = false,
  }) async {
    if (_dancer != null && !forceRefresh) {
      return Right(_dancer!);
    }
    isLoading = true;
    try {
      final result = await authrepo.getUserDetails(uid: uid);

      return result.fold(
          // handle fail
          (fail) => Left(fail),

          // handle success
          (userEntity) {
        _dancer = userEntity;
        isLoading = false;
        return Right(userEntity);
      });
    } catch (e) {
      isLoading = false;
      debugPrint('Provider Error: error with getUserDetails: ${e.toString()}');
      return Left(e.toString());
    }
  }

  /// APPLY FOR JOB
  Future<Either<String, JobApplicationEntity>> applyForJob({
    required JobApplicationEntity application,
  }) async {
    // Instance of job application business logic
    final result =
        await jobApplicationRepo.applyForJob(application: application);
    return result.fold(
      // handle fail
      (fail) => Left(fail),

      // handle success
      (application) => Right(application),
    );
  }

  /// FETCH JOB APPLICATIONS FROM BOTH LOCAL AND REMOTE DB
  Future<Either<String, List<JobApplicationEntity>>> getJobApplications({
    required String jobId,
  }) async {
    try {
      isLoading = true;

      final result = await jobApplicationRepo.getJobApplications(jobId: jobId);

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
        },
      );
    } catch (e) {
      debugPrint('Error with getJobApplications provider: $e');
      return const Left('Error with getJobApplications provider');
    }
  }

  /// ACCEPT JOB
  Future<Either<String, Map<String, dynamic>>> acceptApplication({
    required String applicationId,
  }) async {
    try {
      isLoading = true;
      final result = await jobApplicationRepo.acceptApplication(
        applicationId: applicationId,
      );

      return result.fold(
        // handle fail
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },

        // handle success
        (data) {
          isLoading = false;
          notifyListeners();
          return Right(data);
        },
      );
    } catch (e) {
      debugPrint('Error with accept application provider: ${e.toString()}');
      return Left('Error with accept application provider: ${e.toString()}');
    }
  }

  /// REJECT JOB
  Future<Either<String, Map<String, dynamic>>> rejectApplication({
    required String applicationId,
  }) async {
    try {
      isLoading = true;
      final result = await jobApplicationRepo.rejectApplication(
        applicationId: applicationId,
      );

      return result.fold(
        // handle fail
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },

        // handle success
        (data) {
          isLoading = false;
          notifyListeners();
          return Right(data);
        },
      );
    } catch (e) {
      debugPrint('Error with reject application provider: ${e.toString()}');
      return Left('Error with reject application provider: ${e.toString()}');
    }
  }

  /// FETCH CLIENT DETAILS
  Future<Either<String, UserEntity>> getClientDetails({
    required String clientId,
  }) async {
    try {
      final result = await authrepo.getUserDetails(uid: clientId);

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

  /// FETCH PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS FROM FIRESTORE
  Future<Either<String, List<Map<String, dynamic>>>>
      getPendingApplicationsWithJobs() async {
    try {
      isLoading = true;

      final result = await jobApplicationRepo.getApplicationsWithJobs();

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
          pendingAppsWithJobsList.removeWhere(
            (appWithJob) =>
                appWithJob['application']['applicationStatus'] != 'pending',
          );
          pendingAppsWithJobs = {
            for (var item in pendingAppsWithJobsList)
              JobApplicationModel.fromDoc(item['application']):
                  JobModel.fromDoc(item['job']),
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

      final result = await jobApplicationRepo.getApplicationsWithJobs();

      return result.fold(
        // Handle failure
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },
        // Handle success
        (rejectedAppsWithJobsList) {
          rejectedAppsWithJobsList.removeWhere(
            (appWithJob) =>
                appWithJob['application']['applicationStatus'] != 'rejected',
          );
          // update the map with fetched data
          rejectedAppsWithJobs = {
            for (var item in rejectedAppsWithJobsList)
              JobApplicationModel.fromDoc(item['application']):
                  JobModel.fromDoc(item['job']),
          };
          isLoading = false;
          notifyListeners();
          return Right(rejectedAppsWithJobsList);
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
      // notifyListeners();

      final result = await jobApplicationRepo.getApplicationsWithJobs();

      return result.fold(
        // Handle failure
        (fail) {
          isLoading = false;
          notifyListeners();
          return Left(fail);
        },
        // Handle success
        (acceptedAppsWithJobsList) {
          acceptedAppsWithJobsList.removeWhere(
            (appWithJob) =>
                appWithJob['application']['applicationStatus'] != 'accepted',
          );
          // update the map with fetched data
          acceptedAppsWithJobs = {
            for (var item in acceptedAppsWithJobsList)
              JobApplicationModel.fromDoc(item['application']):
                  JobModel.fromDoc(item['job']),
          };
          isLoading = false;
          notifyListeners();
          return Right(acceptedAppsWithJobsList);
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
