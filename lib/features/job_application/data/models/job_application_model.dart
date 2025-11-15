// ignore_for_file: annotate_overrides

import '../../domain/entities/job_application_entity.dart';
import 'package:hive/hive.dart';

part 'job_application_model.g.dart'; // This file will be generated

@HiveType(typeId: 0) // Unique typeId for Hive

class JobApplicationModel extends JobApplicationEntity {
  @HiveField(0)
  final String applicationId;

  @HiveField(1)
  final String jobId;

  @HiveField(2)
  final String dancerId;

  @HiveField(3)
  final String clientId;

  @HiveField(4)
  String applicationStatus;

  @HiveField(5)
  final String proposal;

  @HiveField(6)
  final DateTime appliedAt;

  JobApplicationModel({
    required this.applicationId, // Primary key
    required this.jobId, // Foreign key
    required this.dancerId, // Foreign key
    required this.clientId, // Foreign key
    required this.applicationStatus,
    required this.proposal,
    required this.appliedAt,
  }) : super(
          applicationId: applicationId,
          jobId: jobId,
          dancerId: dancerId,
          clientId: clientId,
          applicationStatus: applicationStatus,
          proposal: proposal,
          appliedAt: appliedAt,
        );

  factory JobApplicationModel.fromDoc(Map<String, dynamic> doc) {
    return JobApplicationModel(
      applicationId: doc['_id'],
      jobId: doc['jobId'],
      dancerId: doc['dancerId'],
      clientId: doc['clientId'],
      applicationStatus: doc['applicationStatus'],
      proposal: doc['proposal'],
      appliedAt: DateTime.parse(doc['createdAt']),
    );
  }

  /// Convert job application to firebase doc to store in firebase
  Map<String, dynamic> toMap() {
    return {
      'applicationId': applicationId,
      'jobId': jobId,
      'dancerId': dancerId,
      'clientId': clientId,
      'applicationStatus': applicationStatus,
      'proposal': proposal,
      'appliedAt': appliedAt,
    };
  }
}
