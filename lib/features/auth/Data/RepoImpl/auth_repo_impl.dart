import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/domain/Repos/auth_repo.dart';
import 'package:legwork/core/Enums/user_type.dart';
import 'package:legwork/features/auth/Data/Models/user_model.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

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
    dynamic profilePicture,
    String? bio,
    Map<String, dynamic>? resume, // for dancers => 'hiringHistory' for clients
    Map<String, dynamic>? jobPrefs, // for dancer
    String? organizationName, // For clients
    List<dynamic>? danceStylePrefs, // for clients
    List<dynamic>? jobOfferings, // for clients
  }) async {
    try {
      final result = await _authRemoteDataSource.userSignUp(
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
          organisationName: organizationName ?? '', // for clients
          danceStylePrefs: danceStylePrefs, // for clients
          jobOfferings: jobOfferings, // for clients
          jobPrefs: jobPrefs ?? {});

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
    Map<String, dynamic>? jobPrefs, // for dancers
    Map<String, dynamic>? resume, // for dancers => 'hiringHistory' for clients
    List<dynamic>? danceStylePrefs, // for clients
    String? organisationName, // for clients
    List<dynamic>? jobOfferings, // for clients
    required String deviceToken, // Add deviceToken
  }) async {
    try {
      final result = await _authRemoteDataSource.userLogin(
          email: email, password: password, deviceToken: deviceToken);

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
              //jobPrefs: jobPrefs ?? {},
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
              danceStylePrefs: danceStylePrefs ?? [],
              organisationName: organisationName ?? '',
              jobOfferings: jobOfferings ?? [],
              hiringHistory: resume,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Auth repo impl error: $e');
      return Left(e.toString());
    }
  }

  // USER LOG OUT
  @override
  Future<Either<String, void>> userLogout() async {
    try {
      await _authRemoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      debugPrint('Auth repo error logging out: $e');
      return Left(e.toString());
    }
  }

  // GET USERNAME
  @override
  Future<Either<String, String>> getUsername({required String userId}) async {
    try {
      final result = await _authRemoteDataSource.getUsername(userId: userId);
      return result.fold(
        (fail) => Left(fail.toString()),
        (username) => Right(username),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  // GET UID
  @override
  String getUserId() {
    try {
      final result = _authRemoteDataSource.getUserId();
      return result;
    } catch (e) {
      return 'error getting user id';
    }
  }

  String getUserEmail() {
    try {
      final result = _authRemoteDataSource.getUserEmail();
      return result;
    } catch (e) {
      return 'error getting user email';
    }
  }
}
