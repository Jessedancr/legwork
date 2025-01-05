import 'package:dartz/dartz.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

/**
 * THIS CLASS INTERFACES BETWEEN THE DATA LAYER AND THE APP'S BUSINESS LOGIC
 * >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 * CONVERTS THE USER MODEL RETURNED BY THE DATA LAYER INTO A USER ENTITY
 */

abstract class AuthRepo {
  // Login method
  //Future<Either<Fail, UserEntity>> userLogin(String email, String password);

  // Sign up method
  Future<Either<String, UserEntity>> userSignup({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    String? organizationName,
    List<dynamic>? danceStyles 
  });
}
