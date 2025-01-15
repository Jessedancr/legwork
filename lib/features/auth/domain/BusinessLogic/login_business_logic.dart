import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/domain/Repos/auth_repo.dart';

class LoginBusinessLogic {
  // Instance of auth repo
  final AuthRepo authRepo;

  // Constructor
  LoginBusinessLogic({required this.authRepo});

  Future<Either<String, dynamic>> loginExecute({
    required String email,
    required String password,
    required String userType,
  }) async {
    // VALIDATIONS
    if (!email.contains('@')) {
      return const Left('Invalid email format.');
    }
    if (password.isEmpty) {
      return const Left('Password cannot be empty.');
    }

    try {
      final result = await authRepo.userLogin(
        email: email,
        password: password,
        userType: userType,
      );

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
