import 'package:dartz/dartz.dart';
import 'package:legwork/features/auth/domain/Repos/auth_repo.dart';
import 'package:legwork/core/enums/user_type.dart';

class LoginBusinessLogic {
  // Instance of auth repo
  final AuthRepo authRepo;

  // Constructor
  LoginBusinessLogic({required this.authRepo});

  Future<Either<String, dynamic>> loginExecute({
    required String email,
    required String password,
    required UserType userType,
  }) async {
    // TODO: ADD VALIDATION RULES

    final result = await authRepo.userLogin(
      email: email,
      password: password,
      userType: userType,
    );

    return result.fold(
      (fail) => Left(fail),
      (userEntity) => Right(userEntity),
    );
  }
}
