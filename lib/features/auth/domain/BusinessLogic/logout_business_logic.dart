import 'package:dartz/dartz.dart';
import 'package:legwork/features/auth/Data/RepoImpl/auth_repo_impl.dart';

class LogoutBusinessLogic {
  // Instance of auth repo
  final AuthRepoImpl authRepo;

  // Constructor
  LogoutBusinessLogic({required this.authRepo});

  Future<Either<String, void>> logoutExecute() async {
    // Call the logout method from auth repo
    return await authRepo.userLogout();
  }
}
