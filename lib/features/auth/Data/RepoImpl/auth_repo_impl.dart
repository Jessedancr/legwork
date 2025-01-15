import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/Features/auth/domain/Repos/auth_repo.dart';
import 'package:legwork/core/Enums/user_type.dart';
import 'package:legwork/Features/auth/Data/Models/user_model.dart';
import 'package:legwork/Features/auth/domain/Entities/user_entities.dart';

import '../DataSources/auth_remote_data_source.dart';

/**
 * THIS CLASS IMPLEMENTS THE AUTH REPO CLASS
 * Its' purpose is to convert the UserModel returned from the
 * AuthRemoteDataSource class to a UserEntity so it can be used in the app
 */

class AuthRepoImpl implements AuthRepo {
  // Instance of auth remote data source
  final _authRemoteDataSource = AuthRemoteDataSourceImpl();

  // USER SIGN UP
  @override
  Future<Either<String, UserEntity>> userSignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    required UserType userType,
    dynamic porfolio,
    String? organizationName, // For clients
    List<dynamic>? danceStyles, // for dancers
  }) async {
    try {
      final result = await _authRemoteDataSource.userSignUp(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        danceStyles: danceStyles ?? [],
        resume: porfolio,
        organisationName: organizationName ?? '',
        userType: userType,
      );

      // Return either a fail or a dancer or client entity
      return result.fold(
          // Handle failure
          (fail) => Left(fail.toString()),

          // Handle success
          (userModel) {
        if (userType == UserType.dancer) {
          return Right((userModel as DancerModel).toDancerEntity());
        } else {
          return Right((userModel as ClientModel).toClientEntity());
        }
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  // USER LOGIN
  @override
  Future<Either<String, UserEntity>> userLogin({
    required String email,
    required String password,
    String? userType,
    String? firstName,
    String? lastName,
    String? username,
    int? phoneNumber,
    String? bio,
    dynamic profilePicture,
    List<String>? danceStyles, // for dancers
    dynamic resume, // for dancers
  }) async {
    try {
      final result = await _authRemoteDataSource.userLogin(
        email: email,
        password: password,
      );

      // User type check
      if (userType == UserType.dancer.name) {
        return result.fold(
          (fail) => Left(fail.toString()),
          (userEntity) => Right(
            DancerEntity(
              firstName: firstName ?? '',
              lastName: lastName ?? '',
              username: username ?? '',
              email: email,
              password: password,
              phoneNumber: phoneNumber ?? 0,
              danceStyles: danceStyles ?? [],
              resume: resume,
              bio: bio,
              profilePicture: profilePicture,
              userType: UserType.dancer.name,
            ),
          ),
        );
      } else {
        return result.fold(
          (fail) => Left(fail.toString()),
          (userEntity) => Right(
            ClientEntity(
              firstName: firstName ?? '',
              lastName: lastName ?? '',
              username: username ?? '',
              email: email,
              phoneNumber: phoneNumber ?? 0,
              password: password,
              bio: bio,
              profilePicture: profilePicture,
              userType: UserType.client.name,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Auth repo impl error: $e');
      return Left(e.toString());
    }
  }
}
