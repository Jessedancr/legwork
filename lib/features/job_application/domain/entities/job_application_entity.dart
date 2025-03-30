import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplicationEntity {
  final String jobId;
  final String dancerId;
  final String clientId;
  final String applicationId;
  final String applicationStatus; // pending, accepted, rejected
  final String proposal;
  final DateTime appliedAt;

  JobApplicationEntity({
    required this.jobId,
    required this.dancerId,
    required this.clientId,
    required this.applicationId,
    required this.applicationStatus,
    required this.proposal,
    required this.appliedAt,
  });

  // Factory method to create an instance from a map
  factory JobApplicationEntity.fromMap(Map<String, dynamic> map) {
    if (map['jobId'] == null ||
        map['dancerId'] == null ||
        map['clientId'] == null ||
        map['applicationId'] == null ||
        map['applicationStatus'] == null ||
        map['proposal'] == null ||
        map['appliedAt'] == null) {
      throw ArgumentError('Missing required fields in JobApplicationEntity');
    }

    return JobApplicationEntity(
      jobId: map['jobId'] as String,
      dancerId: map['dancerId'] as String,
      clientId: map['clientId'] as String,
      applicationId: map['applicationId'] as String,
      applicationStatus: map['applicationStatus'] as String,
      proposal: map['proposal'] as String,
      appliedAt: (map['appliedAt'] is Timestamp)
          ? (map['appliedAt'] as Timestamp).toDate()
          : map['appliedAt'] as DateTime,
    );
  }
}
