import 'package:dartz/dartz.dart';
import 'package:legwork/features/auth/Domain/Entities/resume_entity.dart';
import 'package:legwork/features/auth/Domain/Repos/resume_repo.dart';

class ResumeBusinessLogic {
  // Instance of resume repo
  final ResumeRepo resumeRepo;

  // Constructor
  ResumeBusinessLogic({required this.resumeRepo});

  // Calling the uploadResume function from ResumeRepo
  Future<Either<String, ResumeEntity>> uploadExecute({
    required String professionalTitle,
    required List<Map<String, dynamic>> workExperience,
    dynamic resumeFile,
  }) async {
    // TODO: ADD VALIDATION RULES
    final result = await resumeRepo.uploadResume(
      professionalTitle: professionalTitle,
      workExperience: workExperience,
    );

    return result.fold(
        // handle fail
        (fail) => Left(fail),

        // Handle success
        (resumeEntity) => Right(resumeEntity));
  }
}
