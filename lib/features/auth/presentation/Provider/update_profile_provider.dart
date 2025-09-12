import 'dart:io';

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

  Future<Either<String, Map<String, dynamic>>> uploadProfileImage({
    required File imageFile,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final result =
          await updateProfile.uploadProfileImage(imageFile: imageFile);
      isLoading = false;
      notifyListeners();

      return result.fold(
        (fail) => Left(fail),
        (success) => Right(success),
      );
    } catch (e) {
      debugPrint('Error with upload profile image provider: ${e.toString()}');
      isLoading = false;
      notifyListeners();
      return const Left('Error with upload profile image provider');
    }
  }
}
