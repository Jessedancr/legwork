class ResumeEntity {
  final String professionalTitle;
  final List<Map<String, dynamic>> workExperience;
  final dynamic resumeFile; // for file upload

  ResumeEntity({
    required this.professionalTitle,
    required this.workExperience,
    this.resumeFile,
  });
}
