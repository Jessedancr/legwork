import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Domain/BusinessLogic/logout_business_logic.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/domain/BusinessLogic/login_business_logic.dart';
import 'package:legwork/features/auth/domain/BusinessLogic/sign_up_business_logic.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:legwork/features/auth/Data/RepoImpl/auth_repo_impl.dart';

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

  /// USER SIGN UP METHOD
  Future<Either<String, dynamic>> userSignUp({
    required UserEntity userEntity,
  }) async {
    SignUpBusinessLogic signUpBusinessLogic =
        SignUpBusinessLogic(authRepo: authRepo);

    isLoading = true;
    notifyListeners();

    try {
      // Call the signUpExecute Func from the SignUpBusinessLogic class
      final result = await signUpBusinessLogic.signUpExecute(
        userEntity: userEntity,
      );

      isLoading = false;
      notifyListeners();

      // signUpExecute returns an Either object so this takes care of both scenarios
      return result.fold(
          // Handle failure
          (fail) {
        debugPrint(fail);
        return Left(fail);
      },
          // Handle success
          (userEntity) {
        _currentUser = userEntity; // Store the user
        debugPrint('user created: $userEntity');
        if (userEntity.userType == UserType.dancer.name) {
          return Right(
            DancerEntity(
              firstName: userEntity.firstName,
              lastName: userEntity.lastName,
              username: userEntity.username,
              email: userEntity.email,
              password: userEntity.password,
              phoneNumber: userEntity.phoneNumber,
              jobPrefs: userEntity.asDancer?.jobPrefs ?? {},
              resume: userEntity.asDancer?.resume,
              userType: userEntity.userType,
              deviceToken: userEntity.deviceToken,
            ),
          );
        } else {
          return Right(
            ClientEntity(
              firstName: userEntity.firstName,
              lastName: userEntity.lastName,
              username: userEntity.username,
              email: userEntity.email,
              phoneNumber: userEntity.phoneNumber,
              password: userEntity.password,
              userType: userEntity.userType,
              danceStylePrefs: userEntity.asClient?.danceStylePrefs ?? [],
              organisationName: userEntity.asClient?.organisationName,
              jobOfferings: userEntity.asClient?.jobOfferings ?? [],
              hiringHistory: userEntity.asClient?.hiringHistory ?? {},
              deviceToken: userEntity.deviceToken,
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
    required UserEntity userEntity,
  }) async {
    LoginBusinessLogic loginBusinessLogic =
        LoginBusinessLogic(authRepo: authRepo);

    isLoading = true;
    notifyListeners();

    try {
      // * User-type-specific data
      final resume = userEntity.asDancer?.resume ?? {};
      final jobPrefs = userEntity.asDancer?.jobPrefs ?? {};
      final organisationName = userEntity.asClient?.organisationName ?? '';
      final danceStylePrefs = userEntity.asClient?.danceStylePrefs ?? [];
      final jobOfferings = userEntity.asClient?.jobOfferings ?? [];
      final result =
          await loginBusinessLogic.loginExecute(userEntity: userEntity);

      return result.fold(
        // Handle failure
        (fail) => Left(fail),

        // Handle success
        (userEntity) {
          _currentUser = userEntity; // Store the user
          if (userEntity.userType == UserType.dancer.name) {
            return Right(
              DancerEntity(
                firstName: userEntity.firstName,
                lastName: userEntity.lastName,
                username: userEntity.username,
                email: userEntity.email,
                password: userEntity.password,
                phoneNumber: userEntity.phoneNumber,
                jobPrefs: jobPrefs,
                resume: resume,
                userType: userEntity.userType,
                deviceToken: userEntity.deviceToken,
              ),
            );
          }
          return Right(
            ClientEntity(
              firstName: userEntity.firstName,
              lastName: userEntity.lastName,
              username: userEntity.username,
              email: userEntity.email,
              phoneNumber: userEntity.phoneNumber,
              password: userEntity.password,
              organisationName: organisationName,
              userType: userEntity.userType,
              danceStylePrefs: danceStylePrefs,
              jobOfferings: jobOfferings,
              deviceToken: userEntity.deviceToken,
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

  Future<Either<String, UserEntity>> getUserDetails({
    required String uid,
  }) async {
    try {
      final result = await authRepo.getUserDetails(uid: uid);

      return result.fold(
          // handle fail
          (fail) => Left(fail),

          // handle success
          (userEntity) {
        _currentUser = userEntity;
        return Right(userEntity);
      });
    } catch (e) {
      debugPrint('Provider Error: error with getUserDetails: ${e.toString()}');
      return Left(e.toString());
    }
  }
}
