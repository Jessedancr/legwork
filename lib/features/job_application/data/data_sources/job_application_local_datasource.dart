import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:legwork/Features/home/data/models/job_model.dart';
import 'package:legwork/Features/job_application/data/models/job_application_model.dart';

class JobApplicationLocalDataSource {
  static const String applicationsBoxName = 'job_applications_box';
  static const String jobsBoxName = 'jobs_box';

  /**
   * BASIC CRUD (SAVE, GET, DELETE)
   */
  //* SAVE APPLICATIONS TO HIVE
  Future<Either<String, void>> saveJobApplication(
    JobApplicationModel application,
  ) async {
    try {
      final box = Hive.box<JobApplicationModel>(applicationsBoxName);
      await box.put(application.applicationId, application);
      debugPrint('Job application saved to hive!');
      return const Right(null);
    } catch (e) {
      debugPrint(
          'An unexpected error occured saving application to hive: ${e.toString()}');
      return Left(
        'An unexpected error occured saving application to hive: ${e.toString()}',
      );
    }
  }

  // * GET APPLICATIONS FROM HIVE
  Future<Either<String, List<JobApplicationModel>>> getJobApplications() async {
    try {
      final box = Hive.box<JobApplicationModel>(applicationsBoxName);
      // box.get(boxName);
      debugPrint('Job application(s) gotten from hive!');
      return Right(box.values.toList());
    } catch (e) {
      debugPrint(
          'An unknown error occured while getting job applications from hive: $e');
      return Left(
          'An unknown error occured while getting job applications from hive: $e');
    }
  }

  // * DELETE APPLICATIONS FROM HIVE
  Future<Either<String, void>> deleteJobApplication(
    String applicationId,
  ) async {
    try {
      final box = Hive.box<JobApplicationModel>(applicationsBoxName);
      await box.delete(applicationId);
      debugPrint('Job deleted from hive!');
      return const Right(null);
    } catch (e) {
      debugPrint(
        'An unknown error occured while deleting job application from hive: $e',
      );
      return Left(
          'An unknown error occured while deleting job application from hive: $e');
    }
  }

  /**
   * CRUD WITH SOME CONDITION
   */
  // * GET PENDING APPLICATIONS FROM HIVE
  Future<Either<String, List<JobApplicationModel>>>
      getPendingApplications() async {
    try {
      final box = Hive.box<JobApplicationModel>(applicationsBoxName);
      List<JobApplicationModel> pendingApplications = box.values
          .where((app) => app.applicationStatus == 'pending')
          .toList();

      return Right(pendingApplications);
    } catch (e) {
      debugPrint('Error fetching pending applications from hive: $e');
      return Left('Erro fetching pending applications from hive: $e');
    }
  }

  // * GET ACCEPTED APPLICATIONS FROM HIVE
  Future<Either<String, List<JobApplicationModel>>>
      getAcceptedApplications() async {
    try {
      final box = Hive.box<JobApplicationModel>(applicationsBoxName);
      List<JobApplicationModel> acceptedApplications = box.values
          .where((app) => app.applicationStatus == 'accepted')
          .toList();

      return Right(acceptedApplications);
    } catch (e) {
      debugPrint('Error fetching accepted applications from hive: $e');
      return Left('Erro fetching accepted applications from hive: $e');
    }
  }

  // * GET REJECTED APPLICATIONS FROM HIVE
  Future<Either<String, List<JobApplicationModel>>>
      getRejectedApplications() async {
    try {
      final box = Hive.box<JobApplicationModel>(applicationsBoxName);
      List<JobApplicationModel> rejectedApplications = box.values
          .where((app) => app.applicationStatus == 'rejected')
          .toList();

      return Right(rejectedApplications);
    } catch (e) {
      debugPrint('Error fetching rejected applications from hive: $e');
      return Left('Erro fetching rejected applications from hive: $e');
    }
  }

  // * GET CORRESPONDING JOBS USING JOBID FROM APPLICATIONS
  Future<Either<String, List<JobModel>>> getJobsForApplications(
    List<JobApplicationModel> applications,
  ) async {
    try {
      final jobsBox = Hive.box<JobModel>(jobsBoxName);
      final jobIds = applications.map((app) => app.jobId).toSet();

      debugPrint('Fetching jobs for job IDs: $jobIds');
      debugPrint('Available job keys in Hive: ${jobsBox.keys}');

      final jobs = jobIds
          .map((id) {
            final job = jobsBox.get(id);
            if (job == null) {
              debugPrint('Warning: No job found for job ID: $id');
            }
            return job;
          })
          .whereType<JobModel>()
          .toList();

      debugPrint('Successfully fetched ${jobs.length} jobs from hive');
      return Right(jobs);
    } catch (e) {
      debugPrint('Error fetching jobs for applications from hive: $e');
      return Left('Error fetching jobs for applications from hive: $e');
    }
  }

  // * GET PENDING APPLICATIONS WITH THEIR CORRESPONDING JOBS
  Future<Either<String, Map<JobApplicationModel, JobModel>>>
      getPendingApplicationsWithJobs() async {
    try {
      // Get pending applications
      final pendingResult = await getPendingApplications();
      return pendingResult.fold(
        // hanlde fail
        (error) => Left(error),

        // handle success
        (pendingApps) async {
          // Get corresponding jobs
          final jobsResult = await getJobsForApplications(pendingApps);
          return jobsResult.fold(
            (error) => Left(error),
            (jobs) {
              // Create a map of application to job
              final jobMap = {for (var job in jobs) job.jobId: job};
              final result = <JobApplicationModel, JobModel>{};

              for (var app in pendingApps) {
                final job = jobMap[app.jobId];
                if (job != null) {
                  result[app] = job;
                }
              }

              return Right(result);
            },
          );
        },
      );
    } catch (e) {
      debugPrint('Error fetching pending applications with jobs: $e');
      return Left('Error fetching pending applications with jobs: $e');
    }
  }

  // * GET ACCEPTED APPLICATIONS WITH THEIR COORESPONDING JOBS
  Future<Either<String, Map<JobApplicationModel, JobModel>>>
      getAcceptedApplicationsWithJobs() async {
    try {
      // Get accepted applications
      final acceptedResult = await getAcceptedApplications();
      return acceptedResult.fold(
          // handle fdil
          (fail) => Left(fail),

          // handle success
          (acceptedApps) async {
        // Get corresponding jobs
        final jobsResult = await getJobsForApplications(acceptedApps);

        return jobsResult.fold(
          // handle fail
          (fail) => Left(fail),

          // handle success
          (jobs) {
            // Create a map of application to job
            final jobMap = {for (var job in jobs) job.jobId: job};
            final result = <JobApplicationModel, JobModel>{};

            for (var app in acceptedApps) {
              final job = jobMap[app.jobId];
              if (job != null) {
                result[app] = job;
              }
            }
            return Right(result);
          },
        );
      });
    } catch (e) {
      debugPrint('Error fetching accepted applications with jobs: $e');
      return Left('Error fetching accepted applications with jobs: $e');
    }
  }

  // * GET REJECTED APPLICATIONS WITH THEIR CORRESPONDING JOBS
  Future<Either<String, Map<JobApplicationModel, JobModel>>>
      getRejectedApplicationsWithJobs() async {
    try {
      // Get rejected applications
      final rejectedResult = await getRejectedApplications();
      return rejectedResult.fold(
        // Handle fail
        (fail) => Left(fail),

        // handle success
        (rejectedApps) async {
          // get corresponding jobs
          final jobsResult = await getJobsForApplications(rejectedApps);
          return jobsResult.fold(
            // handle fail
            (fail) => Left(fail),

            // handle success
            (jobs) {
              // Create a map of application to job
              final jobMap = {for (var job in jobs) job.jobId: job};
              final result = <JobApplicationModel, JobModel>{};

              for (var app in rejectedApps) {
                final job = jobMap[app.jobId];
                if (job != null) {
                  result[app] = job;
                }
              }
              return Right(result);
            },
          );
        },
      );
    } catch (e) {
      debugPrint('Error fetching rejected applications with jobs: $e');
      return Left('Error fetching rejected applications with jobs: $e');
    }
  }

  // * On Accept
  // In this method, we'll change the status of the application to 'accepted'
  // So we can display it in the app
}
