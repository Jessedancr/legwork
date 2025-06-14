import 'package:cloud_firestore/cloud_firestore.dart';

/**
 * JOB ENTITY TO BE USED IN THE APP
 */

class JobEntity {
  final String jobTitle;
  final String jobLocation;
  final List prefDanceStyles;
  final String pay;
  final String amtOfDancers;
  final String jobDuration;
  final String jobDescr;
  final String jobType;
  final String jobId; // Unique Job ID
  final String clientId; // ID of the client who posted the job
  final DateTime createdAt; // Date and time when the job was created
  final bool status;

  // constructor
  JobEntity({
    required this.jobTitle,
    required this.jobLocation,
    required this.prefDanceStyles,
    required this.pay,
    required this.amtOfDancers,
    required this.jobDuration,
    required this.jobDescr,
    required this.jobType,
    required this.jobId, // Unique Job ID
    required this.clientId, // ID of the client who posted the job
    required this.status,
    required this.createdAt,
  });

  // Factory method to create an instance from a map
  factory JobEntity.fromMap(Map<String, dynamic> map) {
    if (map['jobId'] == null ||
        map['jobTitle'] == null ||
        map['jobLocation'] == null ||
        map['clientId'] == null ||
        map['amtOfDancers'] == null ||
        map['jobDuration'] == null ||
        map['jobDescr'] == null ||
        map['jobType'] == null ||
        map['createdAt'] == null ||
        map['pay'] == null ||
        map['status'] == null) {
      throw ArgumentError('Missing required fields in JobEntity');
    }

    return JobEntity(
      jobId: map['jobId'],
      jobTitle: map['jobTitle'],
      jobLocation: map['jobLocation'],
      prefDanceStyles: map['prefDanceStyles'],
      clientId: map['clientId'],
      amtOfDancers: map['amtOfDancers'],
      jobDuration: map['jobDuration'],
      jobDescr: map['jobDescr'],
      jobType: map['jobType'],
      createdAt: (map['createdAt'] is Timestamp)
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] as DateTime,
      pay: map['pay'],
      status: map['status'],
    );
  }

  @override
  String toString() {
    return 'JobEntity(jobTitle: $jobTitle, jobLocation: $jobLocation)';
  }
}
