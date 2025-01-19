import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:legwork/Features/auth/domain/Entities/user_entities.dart';

import '../../../../core/Enums/user_type.dart';

/**
 * TWO MODELS FOR DANCER AND CLIENT
 * 
 * These models are blueprints for the user profiles.
 * It containes everything that is needed to create a user profile.
 */

/**
 * DANCER MODEL CLASS
 */

class DancerModel extends DancerEntity {
  // Constructor
  DancerModel({
    required super.firstName,
    required super.lastName,
    required super.resume,
    required super.danceStyles,
    required super.email,
    required super.password,
    required super.phoneNumber,
    required super.username,
    required super.userType,
    super.profilePicture,
    super.bio,
    super.jobPrefs,
  });

  /// Convert firebase doc to user profile so we can use in the app
  factory DancerModel.fromDocument(DocumentSnapshot doc) {
    return DancerModel(
      firstName: doc['firstName'] ?? '',
      lastName: doc['lastName'] ?? '',
      resume: doc['resume'] ?? {},
      danceStyles: doc['danceStyles'] ?? [],
      email: doc['email'] ?? '',
      password: doc['password'] ?? '',
      phoneNumber: doc['phoneNumber'] ?? 0,
      username: doc['username'] ?? '',
      userType: doc['userType'] ?? 'dancer',
      profilePicture: doc['profilePicture'] ?? '',
      bio: doc['bio'] ?? '',
      jobPrefs: doc['jobPrefs'] ?? [],
    );
  }

  /// Convert user profile to firebase doc to store in firebase
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'danceStyles': danceStyles,
      'resume': resume,
      'userType': UserType.dancer.name, // Include userType
      'profilePicture': profilePicture,
      'bio': bio,
      'jobPrefs': jobPrefs
    };
  }

  // Convert user profile to entity for business logic use
  DancerEntity toDancerEntity() {
    return DancerEntity(
      username: username,
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      danceStyles: danceStyles,
      resume: resume,
      userType: userType,
      profilePicture: profilePicture,
      bio: bio,
      jobPrefs: jobPrefs,
    );
  }
}

/**
 * CLIENT MODEL CLASS
 */
class ClientModel extends ClientEntity {
  // Constructor
  ClientModel({
    required super.email,
    required super.password,
    required super.firstName,
    required super.lastName,
    required super.phoneNumber,
    required super.username,
    required super.userType,
    super.organisationName,
    super.profilePicture,
    super.bio,
  });

  /// Convert firebase doc to user profile so we can use in the app
  factory ClientModel.fromDocument(DocumentSnapshot doc) {
    return ClientModel(
      email: doc['email'] ?? '',
      password: doc['password'] ?? '',
      firstName: doc['firstName'] ?? '',
      lastName: doc['lastName'] ?? '',
      phoneNumber: doc['phoneNumber'] ?? 0,
      username: doc['username'] ?? '',
      organisationName: doc['organisationName'] ?? '',
      profilePicture: doc['profilePicture'],
      userType: doc['userType'] ?? 'client',
      bio: doc['bio'] ?? '',
    );
  }

  /// Convert user profile to firebase doc to store in firebase
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'organisationName': organisationName,
      'profilePicture': profilePicture,
      'userType': UserType.client.name, // Include userType
      'bio': bio,
    };
  }

  // Convert user profile to entity for business logic use
  ClientEntity toClientEntity() {
    return ClientEntity(
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        phoneNumber: phoneNumber,
        password: password,
        organisationName: organisationName,
        profilePicture: profilePicture,
        userType: userType,
        bio: bio);
  }
}
