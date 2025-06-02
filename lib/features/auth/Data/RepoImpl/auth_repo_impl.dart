import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/Data/DataSources/auth_remote_data_source.dart';
import 'package:legwork/features/auth/domain/Repos/auth_repo.dart';

import 'package:legwork/features/auth/Data/Models/user_model.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

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
    required UserEntity userEntity,
  }) async {
    try {
      final result = await _authRemoteDataSource.userSignUp(
        userEntity: userEntity,
      );

      // Return either a fail or a dancer or client entity
      return result.fold(
          // Handle failure
          (fail) => Left(fail.toString()),

          // Handle success
          (userModel) {
        if (userEntity.userType == UserType.dancer.name) {
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
    required UserEntity userEntity,
  }) async {
    // User specific data
    final resume = userEntity.asDancer?.resume ?? {};
    final danceStylePrefs = userEntity.asClient?.danceStylePrefs ?? [];
    final organisationName = userEntity.asClient?.organisationName ?? '';
    final jobOfferings = userEntity.asClient?.jobOfferings ?? [];
    final hiringHistory = userEntity.asClient?.hiringHistory ?? {};
    try {
      final result =
          await _authRemoteDataSource.userLogin(userEntity: userEntity);

      // User type check
      if (userEntity.userType == UserType.dancer.name) {
        return result.fold(
          (fail) => Left(fail.toString()),
          (userEntity) => Right(
            DancerEntity(
              firstName: userEntity.firstName ?? '',
              lastName: userEntity.lastName ?? '',
              username: userEntity.username ?? '',
              email: userEntity.email,
              password: userEntity.password,
              phoneNumber: userEntity.phoneNumber ?? '',
              resume: resume,
              bio: userEntity.bio,
              profilePicture: userEntity.profilePicture,
              userType: UserType.dancer.name,
              deviceToken: userEntity.deviceToken,
            ),
          ),
        );
      } else {
        return result.fold(
          (fail) => Left(fail.toString()),
          (userEntity) => Right(
            ClientEntity(
              firstName: userEntity.firstName ?? '',
              lastName: userEntity.lastName ?? '',
              username: userEntity.username ?? '',
              email: userEntity.email,
              phoneNumber: userEntity.phoneNumber ?? '',
              password: userEntity.password,
              bio: userEntity.bio,
              profilePicture: userEntity.profilePicture,
              userType: UserType.client.name,
              danceStylePrefs: danceStylePrefs,
              organisationName: organisationName,
              jobOfferings: jobOfferings,
              hiringHistory: hiringHistory,
              deviceToken: userEntity.deviceToken,
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

  @override
  Future<Either<String, UserEntity>> getUserDetails({
    required String uid,
  }) async {
    try {
      final result = await _authRemoteDataSource.getUserDetails(uid: uid);
      return result.fold(
        (fail) => Left(fail.toString()),
        (user) => Right(user),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
