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
}
