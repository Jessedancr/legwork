import 'package:dartz/dartz.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

/**
 * THIS CLASS INTERFACES BETWEEN THE DATA LAYER AND THE APP'S BUSINESS LOGIC
 * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 * CONVERTS THE USER MODEL RETURNED BY THE DATA LAYER INTO A USER ENTITY
 */

abstract class AuthRepo {
  // Login method
  Future<Either<String, UserEntity>> userLogin({
    required UserEntity userEntity,
  });

  // Sign up method
  Future<Either<String, UserEntity>> userSignUp({
    required UserEntity userEntity,
  });

  /// LOGOUT METHOD
  Future<Either<String, void>> userLogout();

  // GET UID
  String getUserId();

  // Get device token
  Future<String> getDeviceToken({required String userId});

  /// GET USER DETAILS
  Future<Either<String, UserEntity>> getUserDetails({
    required String uid,
  });
}
