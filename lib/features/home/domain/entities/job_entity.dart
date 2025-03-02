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
    required this.status,
  });

  @override
  String toString() {
    return 'JobEntity(jobTitle: $jobTitle, jobLocation: $jobLocation)';
  }
}
