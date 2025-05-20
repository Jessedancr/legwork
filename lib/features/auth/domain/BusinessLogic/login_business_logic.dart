import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/domain/Repos/auth_repo.dart';

class LoginBusinessLogic {
  // Instance of auth repo
  final AuthRepo authRepo;

  // Constructor
  LoginBusinessLogic({required this.authRepo});

  Future<Either<String, UserEntity>> loginExecute({
    required UserEntity userEntity,
  }) async {
    // VALIDATIONS
    if (!userEntity.email.contains('@')) {
      return const Left('Invalid email format.');
    }
    if (userEntity.password.isEmpty) {
      return const Left('Password cannot be empty.');
    }

    try {
      final result = await authRepo.userLogin(userEntity: userEntity);

      return result.fold(
        (fail) => Left(fail),
        (userEntity) => Right(userEntity),
      );
    } catch (e) {
      debugPrint('LoginBusinessLogic error: $e');
      return Left(e.toString());
    }
  }
}
