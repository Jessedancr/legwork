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

  /// METHOD TO GET THE USERNAME FROM DOCUMENT
  Future<Either<String, String>> getUsername({required String userId});

  // GET UID
  String getUserId();

  /// GET USER DETAILS
  Future<Either<String, UserEntity>> getUserDetails({
    required String uid,
  });
}
