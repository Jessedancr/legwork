import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/Models/user_model.dart';

abstract class AuthRemoteDataSource {
  // Dancer Sign up method
  Future<Either<Fail, DancerModel>> dancerSignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    required List<dynamic> danceStyles
  });

  // Client Sign up method
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Instance of firebase auth and firestore
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  /// DANCER SIGN IN METHOD
  @override
  Future<Either<Fail, DancerModel>> dancerSignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    required List<dynamic> danceStyles,
  }) async {
    try {
      // Sign dancer in
      final userCred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCred.user;

      // Check if user is null
      if (user == null) {
        return Left((Fail('User not found')));
      }

      final uid = user.uid;

      // Save additional information to Firestore
      final dancerData = {
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'danceStyles': danceStyles,
        'portfolio': '', // Default to empty string
        'password': password,
      };

      await db.collection('dancers').doc(uid).set(dancerData);

      // Fetch additional info like username
      DocumentSnapshot userDoc = await db.collection('dancers').doc(uid).get();

      // Convert firebase doc to user profile do we can use in the app
      final dancerModel = DancerModel.fromDocument(userDoc);
      return Right(dancerModel);
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Login error: $e");
      return Left(Fail(e.message ?? 'Unexpected error'));
    }
  }

  /// CLIENT SIGN UP METHOD
}
