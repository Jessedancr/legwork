import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';
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
      final result = await _authRemoteDataSource.dancerSignUp(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        danceStyles: danceStyles ?? [],
        portfolio: porfolio,
        organisationName: organizationName ?? '',
      );

      // Return either a fail or a dancer or client entity
      return result.fold((fail) => Left(fail.toString()), (dancerModel) {
        if (userType == UserType.dancer) {
          return Right(dancerModel.toDancerEntity());
        } else {
          return Right(
            ClientEntity(
              email: email,
              firstName: firstName,
              lastName: lastName,
              password: password,
              phoneNumber: phoneNumber,
              username: username,
              organisationName: organizationName,
            ),
          );
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
    required UserType userType,
    String? firstName,
    String? lastName,
    String? username,
    int? phoneNumber,
  }) async {
    try {
      final result = await _authRemoteDataSource.userLogin(
        email: email,
        password: password,
      );

      // User type check
      if (userType == UserType.dancer) {
        return result.fold(
          (fail) => Left(fail.toString()),
          (userEntity) => Right(userEntity.toDancerEntity()),
        );
      }

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
          ),
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      return Left(e.toString());
    }
  }
}
