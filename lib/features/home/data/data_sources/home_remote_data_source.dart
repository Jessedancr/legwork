import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/DataSources/auth_remote_data_source.dart';
import 'package:legwork/features/home/data/models/job_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobService {
  // POST JOBS
  Future<Either<String, JobModel>> createJob({
    required JobModel job,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final clientId = prefs.getString('userId');

      final jobBody = {...job.toMap(), 'clientId': clientId ?? ''};

      final res =
          await apiClient.post(endpoint: 'jobs/create-job', body: jobBody);

      if (res.statusCode != 201) {
        final resBody = jsonDecode(res.body);
        final message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }

      final resBody = jsonDecode(res.body);
      final jobDoc = resBody['job'];
      final jobId = jobDoc['_id'];
      final jobModel = JobModel.fromDoc({...jobDoc, job.jobId: jobId});
      debugPrint('JOB RETURNED TO USER: $jobModel');
      return Right(jobModel);
    } catch (e) {
      debugPrint('An unknown error occurred while posting job: $e');
      return Left(e.toString());
    }
  }

  /**
   * * This method checks if the logged in user is a client or dancer
   * * If dancer then fetch all jobs from firebase
   * * If client fetch only jobs the client posted
   */
  Future<Either<String, Map<String, List<JobModel>>>> fetchJobs() async {
    try {
      final res = await apiClient.get(endpoint: 'jobs/fetch-jobs');

      if (res.statusCode != 200) {
        final resBody = jsonDecode(res.body);
        final message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }
      final Map<String, dynamic> resBody = jsonDecode(res.body);
      final String message = resBody['message'];
      final List jobs = resBody['jobs'];
      debugPrint(message);

      if (message == 'Jobs found') {
        List<JobModel> allJobs =
            jobs.map((job) => JobModel.fromDoc(job)).toList();
        return Right({'allJobs': allJobs});
      }

      List<JobModel> allClientJobs =
          jobs.map((job) => JobModel.fromDoc(job)).toList();

      List<JobModel> openJobs =
          allClientJobs.where((job) => job.status == true).toList();

      List<JobModel> closedJobs =
          allClientJobs.where((job) => job.status == false).toList();

      return Right({
        'openJobs': openJobs,
        'closedJobs': closedJobs,
      });
    } catch (e) {
      debugPrint('Unknown error while fetching jobs: $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, JobModel>> updateJobStatus({
    required bool status,
    required String jobId,
  }) async {
    try {
      final res = await apiClient.patch(
        endpoint: 'jobs/$jobId/change-status',
        body: {'status': status},
      );
      debugPrint('Update Job status res: ${res.statusCode} - ${res.body}');

      if (res.statusCode != 200) {
        try {
          final resBody = jsonDecode(res.body);
          final message = resBody['message'];
          debugPrint(message);
          return Left(message);
        } catch (e) {
          debugPrint('Error parsing error response: $e');
          return const Left('Error parsing error response');
        }
      }

      try {
        final resBody = jsonDecode(res.body);
        final message = resBody['message'];
        final Map<String, dynamic> result = resBody['result'];
        debugPrint(message);
        final jobModel = JobModel.fromDoc(result);
        return Right(jobModel);
      } catch (e) {
        debugPrint('Error parsing success response: $e');
        return const Left('Error parsing success response');
      }
    } catch (e) {
      debugPrint('Error updating job status');
      return const Left('Error updating job status');
    }
  }
}
