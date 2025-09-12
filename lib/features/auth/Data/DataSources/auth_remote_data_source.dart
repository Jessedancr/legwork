import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/core/network/api_client.dart';
import 'package:legwork/features/auth/Data/Models/resume_model.dart';
import 'package:legwork/features/auth/Data/Models/user_model.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

// * API CLIENT
final ApiClient apiClient = ApiClient();

/**
 * AUTH ABSTRACT CLASS
 */
abstract class AuthRemoteDataSource {
  /// USER SIGN UP METHOD
  Future<Either<String, UserEntity>> userSignUp({
    required UserEntity userEntity,
  });

  /// USER LOGIN METHOD
  Future<Either<String, UserEntity>> userLogin({
    required UserEntity userEntity,
  });

  /// USER LOGOUT METHOD
  Future<Either<String, void>> logout();

  /// GET CURRENLY LOGGED IN USER'S ID FROM FIREBASE AUTH
  String getUserId();

  /// GET CURRENTLY LOGGED IN USER'S ID FROM SHARED PREFS
  Future<String> getUid();

  Future<String> getDeviceToken({required String userId});

  Future<Either<String, UserEntity>> getUserDetails({required String uid});
}

/**
 * CONCRETE IMPLEMENTATION OF AUTH ABSTRACT CLASS
 */
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Instance of firebase auth and firestore
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final storage = const FlutterSecureStorage();

  /// USER SIGN UP METHOD
  @override
  Future<Either<String, UserEntity>> userSignUp({
    required UserEntity userEntity,
  }) async {
    try {
      if (userEntity.userType == UserType.client.name) {
        // * Store client data
        final clientData = {
          'firstName': userEntity.firstName,
          'lastName': userEntity.lastName,
          'username': userEntity.username,
          'organisationName': userEntity.asClient?.organisationName ?? '',
          'password': userEntity.password,
          'password2': userEntity.password,
          'email': userEntity.email,
          'phoneNumber': userEntity.phoneNumber,
          'userType': UserType.client.name, // Store the userType
          'profilePicture': userEntity.profilePicture,
          'bio': userEntity.bio ?? '',
          'danceStylePrefs': userEntity.asClient?.danceStylePrefs ?? [],
          'jobOfferings': userEntity.asClient?.jobOfferings ?? [],
          'hiringHistory': userEntity.asClient?.hiringHistory ?? {},
          'deviceToken': userEntity.deviceToken, // Save device token
        };

        // * Call the API
        final result = await apiClient.authPost(
          endpoint: 'auth/signup',
          body: clientData,
        );

        debugPrint('Sign up API response: ${result.statusCode}');
        if (result.statusCode == 201) {
          // * Decode the response body using jsonDecode
          final resBody = jsonDecode(result.body);

          // * Extract the necessary info from body
          final accessToken = resBody['accessToken'];
          final refreshToken = resBody['refreshToken'];
          final clientData = resBody['client'];
          final userId = clientData['_id'];

          debugPrint('userId: $userId');

          // ! Save the token to secure storage
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: refreshToken);

          // ! USING SHARED PREFS FOR FLUTTER WEB
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('userId', userId);
          final clientModel = ClientModel.fromDoc(clientData);
          return Right(clientModel);
        } else {
          debugPrint('Sign up error: ${result.body}');
          final error = jsonDecode(result.body)['message'] ?? 'Unknown error';
          return Left(error);
        }
      }

      // If user is dancer
      else if (userEntity.userType == UserType.dancer.name) {
        // Store additional dancer's data to firebase
        final dancerData = {
          'firstName': userEntity.firstName,
          'lastName': userEntity.lastName,
          'username': userEntity.username,
          'email': userEntity.email,
          'phoneNumber': userEntity.phoneNumber,
          'jobPrefs': userEntity.asDancer?.jobPrefs ?? {},
          'resume': userEntity.asDancer?.resume ?? {},
          'password': userEntity.password,
          'password2': userEntity.password,
          'profilePicture': userEntity.profilePicture,
          'bio': userEntity.bio ?? '',
          'userType': UserType.dancer.name, // Store the userType
          'deviceToken': userEntity.deviceToken, // Save device token
        };

        final result = await apiClient.authPost(
          endpoint: 'auth/signup',
          body: dancerData,
        );

        debugPrint('Sign up API response: ' '${result.statusCode}');
        if (result.statusCode == 201) {
          // * Decode the response body using jsonDecode
          final resBody = jsonDecode(result.body);

          // * Extract neccessary data from response body
          final accessToken = resBody['accessToken'];
          final refreshToken = resBody['refreshToken'];
          final dancerData = resBody['dancer'];
          final userId = dancerData['_id'];

          // ! Save the token to secure storage
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await storage.write(key: 'accessToken', value: accessToken);
          await storage.write(key: 'refreshToken', value: refreshToken);

          // ! USING SHARED PREFS FOR FLUTTER WEB
          await prefs.setString('accessToken', accessToken);
          await prefs.setString('userId', userId);
          final dancerModel = DancerModel.fromDoc(dancerData);
          return Right(dancerModel);
        } else {
          debugPrint('Sign up error: ${result.body}');
          final error = jsonDecode(result.body)['message'] ?? 'Unknown error';
          return Left(error);
        }
      }
      return const Left('Invalid user type');
    } catch (e) {
      return const Left('An unexpected error occurred.');
    }
  }

  /// USER LOGIN METHOD
  @override
  Future<Either<String, UserEntity>> userLogin({
    required UserEntity userEntity,
  }) async {
    try {
      final loginBody = {
        'usernameOrEmail': userEntity.username,
        'password': userEntity.password
      };
      final response = await apiClient.authPost(
        endpoint: 'auth/login',
        body: loginBody,
      );

      if (response.statusCode != 200) {
        final resBody = jsonDecode(response.body);
        final message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }

      final resBody = jsonDecode(response.body);
      final Map<String, dynamic> user = resBody['user'];
      final String userType = user['userType'];
      final String userId = user['_id'];
      final String accessToken = resBody['accessToken'];
      final refreshToken = resBody['refreshToken'];

      debugPrint('Login API Response: ${response.statusCode}');
      // ! Save the token to secure storage
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);

      // ! USING SHARED PREFS FOR FLUTTER WEB
      await prefs.setString('accessToken', accessToken);
      await prefs.setString('userId', userId);

      // Convert to appropriate user model
      if (userType == UserType.dancer.name) {
        final dancerModel = DancerModel.fromDoc(user);
        return Right(dancerModel);
      } else {
        final clientModel = ClientModel.fromDoc(user);
        return Right(clientModel);
      }
    } catch (e) {
      debugPrint("Unexpected error during login: $e");
      return const Left('An unexpected error occurred');
    }
  }

  /// USER LOGOUT METHOD
  @override
  Future<Either<String, String>> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await apiClient.get(endpoint: 'auth/logout');
      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        final message = resBody['message'];
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'refreshToken');
        await prefs.remove('userId');
        debugPrint('tokens and user ID removed from secure storage');
        debugPrint(message);
        return Right(message);
      }
      return const Left('Error logging out');
    } catch (e) {
      debugPrint('An unknown error occurred while logging out: $e');
      return Left(e.toString());
    }
  }

  // GET CURRENTLY LOGGED IN USER
  @override
  String getUserId() {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return 'user not logged in';
      }
      return user.uid;
    } catch (e) {
      return 'failed to get users uid';
    }
  }

  @override
  Future<String> getUid() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userId');
      return userId!;
    } catch (e) {
      debugPrint('failed to get logged in user\'s ID: ${e.toString()}');
      return 'failed to get users uid';
    }
  }

  @override
  Future<String> getDeviceToken({required String userId}) async {
    try {
      final results = await Future.wait([
        db.collection('dancers').doc(userId).get(),
        db.collection('clients').doc(userId).get()
      ]);
      final dancersDoc = results[0];
      final clientsDoc = results[1];

      if (dancersDoc.exists) {
        return dancersDoc['deviceToken'];
      } else {
        return clientsDoc['deviceToken'];
      }
    } catch (e) {
      debugPrint('Failed to get deviceToken: ${e.toString()}');
      return 'Failed to get device token: ${e.toString()}';
    }
  }

  /// GET USER DETAILS METHOD
  @override
  Future<Either<String, UserEntity>> getUserDetails({
    required String uid,
  }) async {
    try {
      final result =
          await apiClient.get(endpoint: 'users/$uid/get-user-details');

      if (result.statusCode != 200) {
        final resBody = jsonDecode(result.body);
        final message = resBody['message'];
        debugPrint(message);
        return Left(message);
      }

      final resBody = jsonDecode(result.body);
      final user = resBody['user'];
      final userType = user['userType'];

      if (userType == UserType.dancer.name) {
        final dancerModel = DancerModel.fromDoc(user);
        return Right(dancerModel);
      }

      final clientModel = ClientModel.fromDoc(user);
      return Right(clientModel);
    } catch (e) {
      debugPrint('Error getting all of users details: ${e.toString()}');
      return Left(e.toString());
    }
  }
}

/**
 * RESUME UPLOAD ABSTRACT CLASS
 */
abstract class ResumeUploadRemoteDataSource {
  // METHOD TO UPLOAD RESUME
  Future<Either<String, ResumeModel>> uploadResume({
    required String professionalTitle,
    required List<Map<String, dynamic>> workExperience,
    dynamic resumeFile,
  });
}

class ResumeUploadRemoteDataSourceImpl extends ResumeUploadRemoteDataSource {
  // Instance of firebase auth and firestore
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  Future<Either<String, ResumeModel>> uploadResume({
    required String professionalTitle,
    required List<Map<String, dynamic>> workExperience,
    dynamic resumeFile,
  }) async {
    try {
      // Get uid of currently logged in user
      final uid = auth.currentUser!.uid;

      // Get the resume details from user
      final resumeDetails = {
        'professionalTitle': professionalTitle,
        'workExperience': workExperience,
        'resumeFile': resumeFile,
      };

      // Query the database to save the resume details and also retrieve it
      await db.collection('dancers').doc(uid).set(resumeDetails);
      DocumentSnapshot userDoc = await db.collection('dancers').doc(uid).get();

      // Convert firebase doc to Resume  so we can use in app
      final resumeModel = ResumeModel.fromDocument(userDoc);
      return Right(resumeModel);
    } catch (e) {
      debugPrint('error with uploading or updating resume');
      return Left(e.toString());
    }
  }
}

/**
 * UPDATE PROFILE CLASS
 */
class UpdateProfile {
  Future<Either<String, dynamic>> updateUserProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userId');

      if (userId != null) {
        final result = await apiClient.patch(
          endpoint: 'users/$userId/update-user-details',
          body: data,
        );
        debugPrint('Update profile response: ${result.statusCode}');

        if (result.statusCode != 200) {
          String errMessage;
          try {
            final resBody = jsonDecode(result.body);
            errMessage = resBody['message'] ?? 'Update failed';
          } catch (e) {
            errMessage = result.body.isNotEmpty ? result.body : 'update failed';
          }
          debugPrint('Update failed fam: $errMessage');
          return Left(errMessage);
        }

        final resBody = jsonDecode(result.body);
        final message = resBody['message'];

        return Right(message);
      }

      return const Left('User ID not available');
    } catch (e) {
      debugPrint('error updating profile: ${e.toString()}');
      return const Left('Error updating profile');
    }
  }

  Future<Either<String, Map<String, dynamic>>> uploadProfileImage({
    required File imageFile,
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('userId');

      if (userId == null) {
        return const Left('User ID not available');
      }

      final response = await apiClient.uploadFile(
        endpoint: 'users/$userId/upload-profile-image',
        filePath: imageFile.path,
        fieldName: 'profileImage',
      );

      debugPrint('Upload profile picture response: ${response.statusCode}');

      if (response.statusCode != 200) {
        final resBody = jsonDecode(response.body);
        final error = resBody['message'];
        return Left(error);
      }

      final resBody = jsonDecode(response.body);
      final Map<String, dynamic> result = resBody['result'];
      return Right(result);
    } catch (e) {
      debugPrint('Error uploading profile picture: ${e.toString()}');
      return const Left('Error uploading profile picture');
    }
  }
}
