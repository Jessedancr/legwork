import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:legwork/core/enums/user_type.dart';
import 'package:legwork/features/auth/Data/Models/resume_model.dart';
import 'package:legwork/features/auth/Data/Models/user_model.dart';
import 'package:legwork/features/auth/domain/Entities/user_entities.dart';

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

  /// GET CURRENLY LOGGED IN USER'S ID
  String getUserId();

  Future<String> getDeviceToken({required String userId});

  Future<Either<String, UserEntity>> getUserDetails({required String uid});

  /// LISTEN TO AUTH STATE CHANGES
  Stream<User?> authStateChanges();
}

/**
 * CONCRETE IMPLEMENTATION OF AUTH ABSTRACT CLASS
 */
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // Instance of firebase auth and firestore
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  /// USER SIGN UP METHOD
  @override
  Future<Either<String, UserEntity>> userSignUp({
    required UserEntity userEntity,
  }) async {
    try {
      // Sign Useer in
      final userCred = await auth.createUserWithEmailAndPassword(
        email: userEntity.email,
        password: userEntity.password,
      );

      final user = userCred.user;

      // Check if user is null
      if (user == null) {
        return const Left('User not found');
      }
      final uid = user.uid;

      // if user is client
      if (userEntity.userType == UserType.client.name) {
        // Store client data
        final clientData = {
          'firstName': userEntity.firstName,
          'lastName': userEntity.lastName,
          'username': userEntity.username,
          'organisationName': userEntity.asClient?.organisationName ?? '',
          'password': userEntity.password,
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

        await db.collection('clients').doc(uid).set(clientData);
        DocumentSnapshot userDoc =
            await db.collection('clients').doc(uid).get();
        final clientModel = ClientModel.fromDocument(userDoc);
        return Right(clientModel);
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
          'profilePicture': userEntity.profilePicture,
          'bio': userEntity.bio ?? '',
          'userType': UserType.dancer.name, // Store the userType
          'deviceToken': userEntity.deviceToken, // Save device token
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
      if (e.code == 'user-not-found') {
        return const Left('No user found for this email.');
      } else if (e.code == 'wrong-password') {
        return const Left('Incorrect password. Please try again.');
      } else if (e.code == 'invalid-credential') {
        return const Left('Invalid email or password.');
      } else if (e.code == 'network-request-failed') {
        return const Left('Check your internet connection and try again');
      } else if (e.code == 'email-already-in-use') {
        return const Left('Email already in use by another user');
      } else {
        return const Left('An unexpected error occurred.');
      }
    }
  }

  /// USER LOGIN METHOD
  @override
  Future<Either<String, UserEntity>> userLogin({
    required UserEntity userEntity,
  }) async {
    try {
      // sign User in using the sign in method in firebase auth
      final userCred = await auth.signInWithEmailAndPassword(
        email: userEntity.email,
        password: userEntity.password,
      );
      final user = userCred.user;

      // Check if user is null or if user exists
      if (user == null) {
        return const Left('User not found');
      }
      // get uid of current user
      final uid = user.uid;

      // Check the collection based on the user type
      String collection =
          userEntity.userType == UserType.dancer.name ? 'dancers' : 'clients';

      // Query the relevant collection
      final docSnapshot = await db.collection(collection).doc(uid).get();

      if (!docSnapshot.exists) {
        return const Left('User profile not found');
      }

      // Casting the document snapshot to Map so we can extract the user type
      final userData = docSnapshot.data() as Map<String, dynamic>;
      final storedUserType = userData['userType'];

      // Verify the user type matches
      if (storedUserType != userEntity.userType) {
        return const Left('Invalid user type');
      }

      // Update device token of relevant collection
      await db
          .collection(collection)
          .doc(uid)
          .update({'deviceToken': userEntity.deviceToken});
      debugPrint('FCM Token: ${userEntity.deviceToken}');

      // Convert to appropriate user model
      if (userEntity.userType == UserType.dancer.name) {
        final dancerModel = DancerModel.fromDocument(docSnapshot);
        return Right(dancerModel);
      } else {
        final clientModel = ClientModel.fromDocument(docSnapshot);
        return Right(clientModel);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("Firebase Login error: $e");
      if (e.code == 'user-not-found') {
        return const Left('No user found for this email.');
      } else if (e.code == 'wrong-password') {
        return const Left('Incorrect password. Please try again.');
      } else if (e.code == 'invalid-credential') {
        return const Left('Invalid email or password.');
      } else if (e.code == 'network-request-failed') {
        return const Left('Check your internet connection and try again');
      } else if (e.code == 'user-disabled') {
        return const Left('This account has been disabled.');
      } else if (e.code == 'too-many-requests') {
        return const Left(
            'Too many failed login attempts. Please try again later.');
      } else {
        return const Left('An unexpected error occurred.');
      }
    } catch (e) {
      debugPrint("Unexpected error during login: $e");
      return Left('An unexpected error occurred: ${e.toString()}');
    }
  }

  /// USER LOGOUT METHOD
  @override
  Future<Either<String, void>> logout() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return const Left('No user is currently logged in');
      }
      final uid = user.uid;

      // Fetch both documents
      final docs = await Future.wait([
        db.collection('dancers').doc(uid).get(),
        db.collection('clients').doc(uid).get(),
      ]);
      final dancersDoc = docs[0];
      final clientsDoc = docs[1];

      // Only update deviceToken if the document exists
      if (dancersDoc.exists) {
        await db.collection('dancers').doc(uid).update({'deviceToken': ''});
      }
      if (clientsDoc.exists) {
        await db.collection('clients').doc(uid).update({'deviceToken': ''});
      }

      await auth.signOut();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      debugPrint('Error logging out: $e');
      return Left(e.code.toString());
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
      // Query the two collections at the same time
      final docs = await Future.wait([
        db.collection('dancers').doc(uid).get(),
        db.collection('clients').doc(uid).get()
      ]);
      final dancersDoc = docs[0];
      final clientsDoc = docs[1];

      if (dancersDoc.exists && dancersDoc.data() != null) {
        return Right(DancerModel.fromDocument(dancersDoc));
      } else if (clientsDoc.exists && clientsDoc.data() != null) {
        return Right(ClientModel.fromDocument(clientsDoc));
      } else {
        return const Left('No user found');
      }
    } catch (e) {
      debugPrint('Error getting all of users details: ${e.toString()}');
      return Left(e.toString());
    }
  }

  /// LISTEN TO AUTH STATE CHANGES
  @override
  Stream<User?> authStateChanges() {
    return auth.authStateChanges();
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
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  Future<Either<String, dynamic>> updateUserProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      // Get current user and check if null
      final user = auth.currentUser;
      if (user == null) {
        debugPrint('User not found');
        return const Left('User not found');
      }

      // Get current user's uid and check both the dancers and clients collections
      final String uid = user.uid;
      final results = await Future.wait([
        db.collection('dancers').doc(uid).get(),
        db.collection('clients').doc(uid).get()
      ]);

      final dancersDoc = results[0];
      final clientsDoc = results[1];

      // IF DOCUMENT IS IN DANCERS COLLECTION
      if (dancersDoc.exists) {
        await db.collection('dancers').doc(uid).update(data);
        DocumentSnapshot userDoc =
            await db.collection('dancers').doc(uid).get();
        final dancerModel = DancerModel.fromDocument(userDoc);
        return Right(dancerModel);
      }

      // IF DOCUMENT IS IN CLIENTS COLLECTION
      else if (clientsDoc.exists) {
        await db.collection('clients').doc(uid).update(data);
        DocumentSnapshot userDoc =
            await db.collection('clients').doc(uid).get();
        final clientModel = ClientModel.fromDocument(userDoc);
        return Right(clientModel);
      } else {
        return const Left('User not found');
      }
    } catch (e) {
      debugPrint('error updating profile to firebaseeeeeeeee');
      return Left(e.toString());
    }
  }
}
