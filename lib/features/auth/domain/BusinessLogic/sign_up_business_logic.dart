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
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    String? organizationName,
    List<dynamic>? danceStyles = const [], // default to empty list
  }) async {
    // Validating firstname, lastname, username, email and password
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      debugPrint(
          'Firstname, lastname, username and password fields are required');
      return const Left(
        'Firstname, lastname, username and password fields are required',
      );
    }

    // Validating email validity and password length
    if (!email.contains('@gmail.com') || password.length < 6) {
      debugPrint(
          'Only gmail accounts are allowed for now and password must be more than 6 characters');
      return const Left(
          'Omo only gmail accounts are allowed for now and passwords must be more than 6 characters');
    }

    // TODO: ADD SOME MORE VALIDATION RULES

    // Calling the signUp method from authRepo
    return await authRepo.userSignup(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      danceStyles: danceStyles,
    );
  }
}
