import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/job_application_entity.dart';

class JobApplicationModel extends JobApplicationEntity {
  JobApplicationModel({
    required super.applicationId, // Primary key
    required super.jobId, // Foreign key
    required super.dancerId, // Foreign key
    required super.clientId, // Foreign key
    required super.applicationStatus,
    required super.proposal,
    required super.appliedAt,
  });

  /// Convert firebase doc to job application so we can use in the app
  factory JobApplicationModel.fromDocument(DocumentSnapshot doc) {
    return JobApplicationModel(
      applicationId: doc['applicationId'],
      jobId: doc['jobId'],
      dancerId: doc['dancerId'],
      clientId: doc['clientId'],
      applicationStatus: doc['applicationStatus'],
      proposal: doc['proposal'],
      appliedAt: (doc['appliedAt'] as Timestamp).toDate(),
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
      'appliedAt': FieldValue.serverTimestamp(),
    };
  }

  ///? CopyWith() function given to me by chat
  JobApplicationModel copyWith({
    String? dancerId,
    String? clientId,
    String? applicationId,
  }) {
    return JobApplicationModel(
      jobId: jobId,
      dancerId: dancerId ?? this.dancerId,
      clientId: clientId ?? this.clientId,
      applicationId: applicationId ?? this.applicationId,
      applicationStatus: applicationStatus,
      proposal: proposal,
      appliedAt: appliedAt,
    );
  }

  /// Convert job application to entity for business logic use
  JobApplicationEntity toJobApplicationEntity() {
    return JobApplicationEntity(
      jobId: jobId,
      dancerId: dancerId,
      clientId: clientId,
      applicationId: applicationId,
      applicationStatus: applicationStatus,
      proposal: proposal,
      appliedAt: appliedAt,
    );
  }
}
