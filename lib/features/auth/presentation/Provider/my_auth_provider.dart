import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/domain/BusinessLogic/login_business_logic.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

import '../../domain/BusinessLogic/sign_up_business_logic.dart';
import '../../domain/Repos/auth_repo.dart';

class MyAuthProvider extends ChangeNotifier {
  final AuthRepo authRepo; // Instance of auth repo
  bool isLoading = false;

  MyAuthProvider({required this.authRepo});

  /// USER SIGN UP METHOD
  Future<Either<String, dynamic>> userSignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    required UserType userType,
    List<String>? danceStyles, // for dancers
    dynamic portfolio, // for dancers
    String? organisationName, // for clients
  }) async {
    SignUpBusinessLogic signUpBusinessLogic =
        SignUpBusinessLogic(authRepo: authRepo);

    isLoading = true;
    notifyListeners();

    try {
      // Call the signUpExecute Func from the SignUpBusinessLogic class
      final result = await signUpBusinessLogic.signUpExecute(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        userType: userType,
        danceStyles: danceStyles,
        portfolio: portfolio,
        organizationName: organisationName,
      );

      isLoading = false;
      notifyListeners();

      // signUpExecute returns an Either object so this takes care of both scenarios
      return result.fold((fail) {
        debugPrint(fail);
        return Left(fail);
      }, (userEntity) {
        debugPrint('user created: $userEntity');
        if (userType == UserType.dancer) {
          return Right(
            DancerEntity(
              firstName: firstName,
              lastName: lastName,
              username: username,
              email: email,
              password: password,
              phoneNumber: phoneNumber,
              danceStyles: danceStyles!,
              portfolio: portfolio,
              userType: userType.name,
            ),
          );
        } else {
          return Right(
            ClientEntity(
              firstName: firstName,
              lastName: lastName,
              username: username,
              email: email,
              phoneNumber: phoneNumber,
              password: password,
              organisationName: organisationName,
              userType: userType.name,
            ),
          );
        }
      });
    } catch (e) {
      debugPrint('Error with auth provider $e');
      isLoading = false;
      notifyListeners();
      return Left('Omo some Error occured with auth provider $e');
    }
  }

  /// USER LOGIN FUNCTION
  Future<Either<String, dynamic>> userlogin({
    required String email,
    required String password,
    required String? userType,
    String? firstName,
    String? lastName,
    String? username,
    int? phoneNumber,
    List<String>? danceStyles, // for dancers
    dynamic portfolio, // for dancers,
    String? organisationName, // for clients
  }) async {
    LoginBusinessLogic loginBusinessLogic =
        LoginBusinessLogic(authRepo: authRepo);

    isLoading = true;
    notifyListeners();

    try {
      final result = await loginBusinessLogic.loginExecute(
        email: email,
        password: password,
        userType: userType ?? 'dancer'
      );

      return result.fold(
          // Handle failure
          (fail) => Left(fail),

          // Handle success
          (userEntity) {
        if (userType == UserType.dancer.name) {
          return Right(
            DancerEntity(
              firstName: firstName ?? '',
              lastName: lastName ?? '',
              username: username ?? '',
              email: email,
              password: password,
              phoneNumber: phoneNumber ?? 0,
              danceStyles: danceStyles ?? [],
              portfolio: portfolio,
              userType: userType ?? 'dancer',
            ),
          );
        }
        return Right(
          ClientEntity(
            firstName: firstName ?? '',
            lastName: lastName ?? '',
            username: username ?? '',
            email: email,
            phoneNumber: phoneNumber ?? 0,
            password: password,
            organisationName: organisationName,
            userType: userType ?? 'client',
          ),
        );
      });
    } catch (e) {
      debugPrint('Error with auth provider $e');
      isLoading = false;
      notifyListeners();
      return Left('Omo some Error occured with auth provider $e');
    }
  }
}
