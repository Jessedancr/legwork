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

      return result.fold((fail) => Left(fail.toString()),

          // Handle success
          (returnedUser) {
        // * Return dancer
        if (returnedUser.userType == UserType.dancer.name) {
          return Right(
            DancerEntity(
              firstName: returnedUser.firstName,
              lastName: returnedUser.lastName,
              username: returnedUser.username,
              email: returnedUser.email,
              password: returnedUser.password,
              phoneNumber: returnedUser.phoneNumber,
              userType: UserType.dancer.name,
              deviceToken: returnedUser.deviceToken,
              resume: resume,
              userId: returnedUser.userId,
            ),
          );
        }

        // * Return client
        else if (returnedUser.userType == UserType.client.name) {
          return Right(
            ClientEntity(
              firstName: returnedUser.firstName,
              lastName: returnedUser.lastName,
              username: returnedUser.username,
              email: returnedUser.email,
              phoneNumber: returnedUser.phoneNumber,
              password: returnedUser.password,
              userType: UserType.client.name,
              deviceToken: returnedUser.deviceToken,
              danceStylePrefs: danceStylePrefs,
              organisationName: organisationName,
              jobOfferings: jobOfferings,
              hiringHistory: hiringHistory,
              userId: returnedUser.userId,
            ),
          );
        } else {
          return const Left('Unknown user type returned from server');
        }
      });
    } catch (e) {
      debugPrint('Auth repo impl error: $e');
      return Left(e.toString());
    }
  }

  // USER LOG OUT
  @override
  Future<Either<String, String>> userLogout() async {
    try {
      final result = await _authRemoteDataSource.logout();
      return result.fold(
        (fail) => Left(fail),
        (msg) => Right(msg),
      );
    } catch (e) {
      debugPrint('Auth repo error logging out: $e');
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

  Future<String> getUid() async {
    try {
      final result = await _authRemoteDataSource.getUid();
      return result;
    } catch (e) {
      return 'Error getting user ID';
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

  @override
  Future<String> getDeviceToken({required String userId}) async {
    try {
      final result = await _authRemoteDataSource.getDeviceToken(userId: userId);
      return result;
    } catch (e) {
      return e.toString();
    }
  }
}
