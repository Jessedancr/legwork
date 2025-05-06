import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/DataSources/auth_remote_data_source.dart';

class UpdateProfileProvider extends ChangeNotifier {
  final UpdateProfile updateProfile = UpdateProfile();
  bool isLoading = false;

  /// UPDATE PROFILE METHOD
  Future<Either<String, dynamic>> updateProfileExecute({
    required Map<String, dynamic> data,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final result = await updateProfile.updateUserProfile(data: data);
      isLoading = false;
      notifyListeners();
      return result.fold(
        (fail) => Left(fail.toString()),
        (success) {
          debugPrint('Profile updated successfully');
          return Right(success);
        },
      );
    } catch (e) {
      debugPrint('error with update profile provider');
      isLoading = false;
      notifyListeners();
      return Left(e.toString());
    }
  }
}
