import 'package:dartz/dartz.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/domain/Repos/auth_repo.dart';

import '../DataSources/auth_remote_data_source.dart';

/**
 * THIS CLASS IMPLEMENTS THE AUTH REPO CLASS
 * Its' purpose is to convert the UserModel returned from the
 * AuthRemoteDataSource class to a UserEntity so it can be used in the app
 */

class AuthRepoImpl implements AuthRepo {
  // Instance of auth remote data source
  final _authRemoteDataSource = AuthRemoteDataSourceImpl();
  @override
  Future<Either<String, UserEntity>> userSignup({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    String? organizationName, // Optional for clients
    List<dynamic>? danceStyles
    
  }) async {
    try {
      final result = await _authRemoteDataSource.dancerSignUp(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        danceStyles: danceStyles ?? [],
      );

      return result.fold(
        (fail) => Left(fail.toString()),
        (dancerModel) => Right(dancerModel.toDancerEntity()),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
