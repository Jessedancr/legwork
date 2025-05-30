import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/domain/Repos/auth_repo.dart';

class SignUpBusinessLogic {
  // Instance of auth repo
  final AuthRepo authRepo;

  // Constructor
  SignUpBusinessLogic({required this.authRepo});

  // Calling the signUp method from authRepo
  Future<Either<String, UserEntity>> signUpExecute({
    required UserEntity userEntity,
  }) async {
    // Validating firstname, lastname, username, email and password
    if (userEntity.firstName.isEmpty ||
        userEntity.lastName.isEmpty ||
        userEntity.username.isEmpty ||
        userEntity.password.isEmpty) {
      debugPrint(
          'Firstname, lastname, username and password fields are required');
      return const Left(
        'Firstname, lastname, username and password fields are required',
      );
    }

    // Validating email  and password length
    if (!userEntity.email.contains('@gmail.com')) {
      debugPrint('Only gmail accounts are allowed for now ');
      return const Left('Omo only gmail accounts are allowed for now');
    }

    if (userEntity.password.length < 6) {
      debugPrint('Password must be at least 6 characters');
      return const Left('Password must be at least 6 characters');
    }

    // Calling the signUp method from authRepo
    final result = await authRepo.userSignUp(
      userEntity: userEntity,
    );

    return result.fold(
      (fail) => Left(fail),
      (userEntity) => Right(userEntity),
    );
  }
}
