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
  final DateTime? createdAt; // Date and time when the job was created
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
    this.createdAt,
  });

  @override
  String toString() {
    return 'JobEntity(jobTitle: $jobTitle, jobLocation: $jobLocation)';
  }
}
