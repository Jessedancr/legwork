import 'package:flutter/material.dart';
import 'package:legwork/Features/home/domain/entities/job_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'job_model.g.dart';

/**
 * THIS IS A BLUEPRINT FOR A POSTED JOB
 * 
 * This model represents the things and attributes a posted job should have
 */

@HiveType(typeId: 1) // Unique typeId for Hive
class JobModel extends JobEntity {
  @HiveField(0)
  final String jobTitle;

  @HiveField(1)
  final String jobLocation;

  @HiveField(2)
  final List prefDanceStyles;

  @HiveField(3)
  final String pay;

  @HiveField(4)
  final String amtOfDancers;

  @HiveField(5)
  final String jobDuration;

  @HiveField(6)
  final String jobDescr;

  @HiveField(7)
  final String jobType;

  @HiveField(8)
  final bool status;

  @HiveField(9)
  final String clientId;

  @HiveField(10)
  final String jobId;

  @HiveField(11)
  final DateTime createdAt;

  JobModel({
    required this.jobTitle,
    required this.jobLocation,
    required this.prefDanceStyles,
    required this.pay,
    required this.amtOfDancers,
    required this.jobDuration,
    required this.jobDescr,
    required this.jobType,
    required this.status,
    required this.clientId,
    required this.jobId,
    required this.createdAt,
  }) : super(
          jobTitle: jobTitle,
          jobLocation: jobLocation,
          prefDanceStyles: prefDanceStyles,
          pay: pay,
          amtOfDancers: amtOfDancers,
          jobDuration: jobDuration,
          jobDescr: jobDescr,
          jobType: jobType,
          status: status,
          clientId: clientId,
          jobId: jobId,
          createdAt: createdAt,
        );

  /// Convert firebase doc to user profile so we can use in the app
  factory JobModel.fromDocument(DocumentSnapshot doc) {
    // Ensure createdAt is converted to DateTime
    DateTime createdAtDateTime;
    if (doc['createdAt'] != null && doc['createdAt'] is Timestamp) {
      createdAtDateTime = (doc['createdAt'] as Timestamp).toDate();
    } else {
      createdAtDateTime = DateTime.now();
      debugPrint(
          "Warning: createdAt was not a Timestamp, using default value.");
    }
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
      clientId: doc['clientId'] ?? '',
      status: doc['status'] ?? true,
      createdAt: createdAtDateTime,
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
      'status': status,
      'clientId': clientId,
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
        jobId: jobId,
        clientId: clientId,
        status: status,
        createdAt: createdAt);
  }
}
