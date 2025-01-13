import 'package:dartz/dartz.dart';
import 'package:legwork/Features/auth/Domain/Entities/resume_entity.dart';

abstract class ResumeRepo {
  Future<Either<String, ResumeEntity>> uploadResume({
    required String professionalTitle,
    required List<Map<String, dynamic>> workExperience,
    dynamic resumeFile,
  });
}
