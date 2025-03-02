import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * THIS IS A BLUEPRINT FOR A POSTED JOB
 * 
 * This model represents the things and attributes a posted job should have
 */

class JobModel extends JobEntity {
  final String jobId;
  JobModel({
    required super.jobTitle,
    required super.jobLocation,
    required super.prefDanceStyles,
    required super.pay,
    required super.amtOfDancers,
    required super.jobDuration,
    required super.jobDescr,
    required super.jobType,
    required super.status,
    required this.jobId,
  });

  /// Convert firebase doc to user profile so we can use in the app
  factory JobModel.fromDocument(DocumentSnapshot doc) {
    return JobModel(
      jobTitle: doc['jobTitle'] ?? '',
      jobLocation: doc['jobLocation'] ?? '',
      prefDanceStyles: doc['prefDanceStyles'] ?? [],
      pay: doc['pay'] ?? '',
      amtOfDancers: doc['amtOfDancers'] ?? '',
      jobDuration: doc['jobDuration'] ?? '',
      jobDescr: doc['jobDescr'] ?? '',
      jobType: doc['jobType'],
      jobId: doc['jobId'] ?? '',
      status: doc['status'] ?? true
    );
  }

  /// Convert Job to firebase doc to store in firebase
  Map<String, dynamic> toMap() {
    return {
      'jobTitle': jobTitle,
      'jobLocation': jobLocation,
      'prefDanceStyles': prefDanceStyles,
      'pay': pay,
      'amtOfDancers': amtOfDancers,
      'jobDuration': jobDuration,
      'jobDescr': jobDescr,
      'jobType': jobType,
      'jobId': jobId,
      'status': status
    };
  }

  /// Convert job to entity foe business logic use
  JobEntity toJobEntity() {
    return JobEntity(
      jobTitle: jobTitle,
      jobLocation: jobLocation,
      prefDanceStyles: prefDanceStyles,
      pay: pay,
      amtOfDancers: amtOfDancers,
      jobDuration: jobDuration,
      jobType: jobType,
      jobDescr: jobDescr,
      status:  status
    );
  }
}
