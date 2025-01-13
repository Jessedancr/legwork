import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:legwork/Features/auth/Domain/BusinessLogic/resume_business_logic.dart';
import 'package:legwork/Features/auth/Domain/Entities/resume_entity.dart';
import 'package:legwork/Features/auth/Domain/Repos/resume_repo.dart';



class ResumeProvider extends ChangeNotifier {
  // Instance of resume repo
  final ResumeRepo resumeRepo;
  bool isLoading = false;

  // Constructor
  ResumeProvider({required this.resumeRepo});

  /// RESUME UPLOAD METHOD
  Future<Either<String, ResumeEntity>> uploadResume({
    required String professionalTitle,
    required List<Map<String, dynamic>> workExperience,
    dynamic resumeFile,
  }) async {
    ResumeBusinessLogic resumeBusinessLogic =
        ResumeBusinessLogic(resumeRepo: resumeRepo);

    isLoading = true;
    notifyListeners();
    try {
      final result = await resumeBusinessLogic.uploadExecute(
        professionalTitle: professionalTitle,
        workExperience: workExperience,
      );

      isLoading = false;
      notifyListeners();

      return result.fold(
          // handle fail
          (fail) {
        debugPrint('failed to upload resume $fail');
        return Left(fail);
      },
          // handle success
          (resumeEntity) {
        debugPrint('resume uploaded: $resumeEntity');
        return Right(resumeEntity);
      });
    } catch (e) {
      debugPrint('error with resume upload provider');
      isLoading = false;
      notifyListeners();
      return Left('Omo some Error occured with resume upload provider $e');
    }
  }
}
