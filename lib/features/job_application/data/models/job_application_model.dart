import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/job_application_entity.dart';

class JobApplicationModel extends JobApplicationEntity {
  JobApplicationModel({
    required super.jobId,
    required super.dancerId,
    required super.clientId,
    required super.applicationStatus,
    required super.proposal,
    required super.appliedAt,
  });

  /// Convert firebase doc to job application so we can use in the app
  factory JobApplicationModel.fromDocument(DocumentSnapshot doc) {
    return JobApplicationModel(
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
      'jobId': jobId,
      'dancerId': dancerId,
      'clientId': clientId,
      'applicationStatus': applicationStatus,
      'proposal': proposal,
      'appliedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Convert job application to entity for business logic use
  JobApplicationEntity toJobApplicationEntity() {
    return JobApplicationEntity(
      jobId: jobId,
      dancerId: dancerId,
      clientId: clientId,
      applicationStatus: applicationStatus,
      proposal: proposal,
      appliedAt: appliedAt,
    );
  }
}
