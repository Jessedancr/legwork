import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/features/auth/Data/Models/user_model.dart';

import '../../../../core/enums/user_type.dart';

abstract class AuthRemoteDataSource {
  /// DANCER SIGN UP METHOD
  Future<Either<String, dynamic>> userSignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    List<dynamic>? danceStyles,
    dynamic portfolio,
    required UserType userType,
  });

  /// CLIENT SIGN UP METHOD

  /// USER LOGIN METHOD
  Future<Either<String, dynamic>> userLogin({
    required String email,
    required String password,
  });
}

/**
 * CONCRETE IMPLEMENTATION
 */

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Instance of firebase auth and firestore
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  /// USER SIGN IN METHOD
  // TODO: MAKE PORTFOLIO A MAP
  @override
  Future<Either<String, dynamic>> userSignUp({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required int phoneNumber,
    required String password,
    List<dynamic>? danceStyles, // for dancers
    String? organisationName, // for clients
    dynamic portfolio, // For dancers
    required UserType userType,
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
        return const Left('User not found');
      }
      final uid = user.uid;

      if (userType == UserType.client) {
        // Store client data
        final clientData = {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'organisationName': organisationName,
          'password': password,
          'email': email,
          'phoneNumber': phoneNumber,
          'userType': UserType.client.name, // Store the userType
        };

        await db.collection('clients').doc(uid).set(clientData);
        DocumentSnapshot userDoc =
            await db.collection('clients').doc(uid).get();
        final clientModel = ClientModel.fromDocument(userDoc);
        return Right(clientModel);
      } else if (userType == UserType.dancer) {
        // Store additional dancer's data to firebase
        final dancerData = {
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          'danceStyles': danceStyles,
          'portfolio': portfolio,
          'password': password,
          'userType': UserType.dancer.name, // Store the userType
        };

        await db.collection('dancers').doc(uid).set(dancerData);

        // Fetch additional info like username
        DocumentSnapshot userDoc =
            await db.collection('dancers').doc(uid).get();

        // Convert firebase doc to user profile do we can use in the app
        final dancerModel = DancerModel.fromDocument(userDoc);
        return Right(dancerModel);
      }
      return const Left('Invalid user type');
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Signup error: $e");
      return Left(e.message ?? 'Unexpected error');
    }
  }

  /// USER LOGIN METHOD
  @override
  Future<Either<String, dynamic>> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      // sign User in using the sign in method in firebase auth
      final userCred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCred.user;

      // Check if user is null or if user exists
      if (user == null) {
        return const Left('User not found');
      }
      // get uid of current user
      final uid = user.uid;

      // the Future.wait method checks both collections at the same time
      final results = await Future.wait([
        db.collection('dancers').doc(uid).get(),
        db.collection('clients').doc(uid).get()
      ]);
      final dancersDoc = results[0];
      final clientsDoc = results[1];

      // Check if the document is in the dancers collection and if it has userType field
      if (dancersDoc.exists) {
        debugPrint('Dancer Document: ${dancersDoc.data()}');

        // Extracting the data fronm the dancers doc using the .data() method and converting it to a map
        final dancersData = dancersDoc.data() as Map<String, dynamic>;
        final userType = dancersData['userType'];
        if (userType == UserType.dancer.name) {
          // convert firebase doc to user profile so we can use in the app
          final dancerModel = DancerModel.fromDocument(dancersDoc);
          return Right(dancerModel);
        }
      }

      // Same check for client
      else if (clientsDoc.exists) {
        debugPrint('Client Document: ${clientsDoc.data()}');

        // Extracting the data fronm the dancers doc using the .data() method and converting it to a map
        final clientsData = clientsDoc.data() as Map<String, dynamic>;
        final userType = clientsData['userType'];
        if (userType == UserType.client.name) {
          // convert firebase doc to user profile so we can use in the app
          final clientModel = ClientModel.fromDocument(clientsDoc);
          return Right(clientModel);
        }
      }
      debugPrint('User not found brr');
      return const Left('User not found');
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase  Login error: $e");
      return Left(e.toString());
    }
  }
}
