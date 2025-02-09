import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/Data/RepoImpl/auth_repo_impl.dart';
import 'package:legwork/core/Enums/user_type.dart';
import 'package:legwork/Features/auth/domain/Entities/user_entities.dart';

class SignUpBusinessLogic {
  // Instance of auth repo
  final AuthRepoImpl authRepo;

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
    required UserType userType,
    dynamic profilePicture,
    String? bio,
    Map<String, dynamic>? resume, // for dancers => 'hiringHistory' for clients
    Map<String, dynamic>? jobPrefs, // for dancers
    String? organizationName, // for clients
    List<dynamic>? danceStylePrefs, // for clients
    List<dynamic>? jobOfferings, // for clients
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

    // Validating email  and password length
    if (!email.contains('@gmail.com')) {
      debugPrint('Only gmail accounts are allowed for now ');
      return const Left('Omo only gmail accounts are allowed for now');
    }

    // TODO: ADD SOME MORE VALIDATION RULES
    if (password.length < 6) {
      debugPrint('Password must be at least 6 characters');
      return const Left('Password must be at least 6 characters');
    }

    // Calling the signUp method from authRepo
    final result = await authRepo.userSignUp(
      firstName: firstName,
      lastName: lastName,
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      userType: userType,
      bio: bio,
      profilePicture: profilePicture,
      resume: resume, // for dancers => 'hiringHistory' for clients
      organizationName: organizationName, // for clients
      danceStylePrefs: danceStylePrefs, // for clients
      jobOfferings: jobOfferings, // for clients
      jobPrefs: jobPrefs
    );

    return result.fold(
      (fail) => Left(fail),
      (userEntity) => Right(userEntity),
    );
  }
}
