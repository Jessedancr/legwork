import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Domain/BusinessLogic/logout_business_logic.dart';
import 'package:legwork/core/Enums/user_type.dart';
import 'package:legwork/features/auth/domain/BusinessLogic/login_business_logic.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/Data/RepoImpl/auth_repo_impl.dart';

import '../../domain/BusinessLogic/sign_up_business_logic.dart';

class MyAuthProvider extends ChangeNotifier {
  // Instance of auth repo
  final AuthRepoImpl authRepo;

  bool isLoading = false;

  MyAuthProvider({
    required this.authRepo,
  });

  // Add a private field to store the current user
  UserEntity? _currentUser;

  // Getter to retrieve the currently logged in user
  UserEntity? get currentUser => _currentUser;
  String? get currentUserUsername => _currentUser?.username;

  // String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  /// USER SIGN UP METHOD
  Future<Either<String, dynamic>> userSignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    required UserType userType,
    Map<String, dynamic>? resume, // for dancers
    Map<String, dynamic>? jobPrefs, // for dancers
    String? organisationName, // for clients
    List<dynamic>? danceStylePrefs, // for clients
    List<dynamic>? jobOfferings, // for clients
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
        resume: resume,
        organizationName: organisationName,
      );

      isLoading = false;
      notifyListeners();

      // signUpExecute returns an Either object so this takes care of both scenarios
      return result.fold((fail) {
        debugPrint(fail);
        return Left(fail);
      }, (userEntity) {
        _currentUser = userEntity; // Store the user
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
              jobPrefs: jobPrefs ?? {},
              resume: resume,
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
              userType: userType.name,
              danceStylePrefs: danceStylePrefs ?? [],
              organisationName: organisationName,
              jobOfferings: jobOfferings ?? [],
              hiringHistory: resume ?? {},
            ),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      debugPrint('Error with auth provider $e');
      isLoading = false;
      notifyListeners();
      if (e.code == 'user-not-found') {
        return const Left('No user found for this email.');
      } else if (e.code == 'wrong-password') {
        return const Left('Incorrect password. Please try again.');
      } else if (e.code == 'invalid-email') {
        return const Left('The email address is not valid.');
      } else {
        return const Left('An unexpected error occurred.');
      }
    }
  }

  /// USER LOGIN METHOD
  Future<Either<String, dynamic>> userlogin({
    required String email,
    required String password,
    required String? userType,
    String? firstName,
    String? lastName,
    String? username,
    int? phoneNumber,
    Map<String, dynamic>? jobPrefs, // for dancers
    dynamic portfolio, // for dancers,
    String? organisationName, // for clients
    List<dynamic>? danceStylePrefs, // for clients
    List<dynamic>? jobOfferings,
    required String deviceToken, // Add deviceToken
  }) async {
    LoginBusinessLogic loginBusinessLogic =
        LoginBusinessLogic(authRepo: authRepo);

    isLoading = true;
    notifyListeners();

    try {
      final result = await loginBusinessLogic.loginExecute(
        email: email,
        password: password,
        userType: userType ?? 'dancer',
        deviceToken: deviceToken,
      );

      return result.fold(
        // Handle failure
        (fail) => Left(fail),

        // Handle success
        (userEntity) {
          _currentUser = userEntity; // Store the user
          if (userType == UserType.dancer.name) {
            return Right(
              DancerEntity(
                firstName: firstName ?? '',
                lastName: lastName ?? '',
                username: username ?? '',
                email: email,
                password: password,
                phoneNumber: phoneNumber ?? 0,
                jobPrefs: jobPrefs ?? {},
                resume: portfolio,
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
              danceStylePrefs: danceStylePrefs ?? [],
              jobOfferings: jobOfferings ?? [],
            ),
          );
        },
      );
    } catch (e) {
      debugPrint('Caught Unknown exception: $e');
      isLoading = false;
      notifyListeners();
      return Left(e.toString());
    }
  }

  /// USER LOGOUT METHOD
  Future<Either<String, void>> logout() async {
    LogoutBusinessLogic logoutBusinessLogic =
        LogoutBusinessLogic(authRepo: authRepo);

    isLoading = true;
    notifyListeners();

    try {
      await logoutBusinessLogic.logoutExecute();
      return const Right(null);
    } catch (e) {
      debugPrint('Error with logout: $e');
      return Left(e.toString());
    }
  }

  /// GET USER UID
  String getUserId() {
    final result = authRepo.getUserId();
    return result;
  }

  /// GET USER EMAIL
  String getUserEmail() {
    final result = authRepo.getUserEmail();
    return result;
  }
}
