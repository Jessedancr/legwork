import 'package:dartz/dartz.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

// import '../../../../core/Enums/user_type.dart';

/**
 * THIS CLASS INTERFACES BETWEEN THE DATA LAYER AND THE APP'S BUSINESS LOGIC
 * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 * CONVERTS THE USER MODEL RETURNED BY THE DATA LAYER INTO A USER ENTITY
 */

abstract class AuthRepo {
  // Login method
  Future<Either<String, UserEntity>> userLogin({
    required String email,
    required String password,
    String userType,
    required String deviceToken, // Add deviceToken
  });

  // Sign up method
  Future<Either<String, UserEntity>> userSignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
    required UserType userType,
    Map<String, dynamic>? resume,
    Map<String, dynamic>? jobPrefs, // for dancer
    String? organizationName, // for client
    required String deviceToken, // Add deviceToken
  });

  /// LOGOUT METHOD
  Future<Either<String, void>> userLogout();

  /// METHOD TO GET THE USERNAME FROM DOCUMENT
  Future<Either<String, String>> getUsername({required String userId});

  // GET UID
  String getUserId();
}
