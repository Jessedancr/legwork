import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

import '../../domain/BusinessLogic/sign_up_business_logic.dart';
import '../../domain/Repos/auth_repo.dart';

class MyAuthProvider extends ChangeNotifier {
  final AuthRepo authRepo; // Instance of auth repo
  bool isLoading = false;

  MyAuthProvider({required this.authRepo});

  // Sign up function
  Future<Either<String, DancerEntity>> dancerSignUpFunction({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    required List<String> danceStyles,
    dynamic portfolio,
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
        danceStyles: danceStyles,
      );

      isLoading = false;
      notifyListeners();

      // signUpExecute returns an Either object so this takes care of both scenarios
      return result.fold((fail) {
        debugPrint(fail);
        return Left(fail);
      }, (user) {
        debugPrint('user created: $user');
        return Right(
          DancerEntity(
            firstName: firstName,
            lastName: lastName,
            username: username,
            email: email,
            password: password,
            phoneNumber: phoneNumber,
            danceStyles: danceStyles,
            portfolio: portfolio,
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
