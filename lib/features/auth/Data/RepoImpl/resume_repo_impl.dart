import 'package:dartz/dartz.dart';
import 'package:legwork/Features/auth/Domain/Entities/resume_entity.dart';

import '../../Domain/Repos/resume_repo.dart';
import '../DataSources/auth_remote_data_source.dart';

class ResumeRepoImpl implements ResumeRepo {
  // Instance of auth remote data source
  final resumeUploadRemoteDataSource = ResumeUploadRemoteDataSourceImpl();

  @override
  Future<Either<String, ResumeEntity>> uploadResume({
    required String professionalTitle,
    required List<Map<String, dynamic>> workExperience,
    resumeFile,
  }) async {
    try {
      final result = await resumeUploadRemoteDataSource.uploadResume(
        professionalTitle: professionalTitle,
        workExperience: workExperience,
      );

      // Return either a fail or resume entity
      return result.fold(
          // handle fail
          (fail) => Left(fail.toString()),

          // handle success
          (resumeEntity) {
        return Right(ResumeEntity(
          professionalTitle: professionalTitle,
          workExperience: workExperience,
        ));
      });
    } catch (e) {
      return Left(e.toString());
    }
  }
}
