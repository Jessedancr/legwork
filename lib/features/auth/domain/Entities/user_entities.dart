/**
 * BASE ENTITY FOR USER
 */
class UserEntity {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String phoneNumber;
  final String password;
  final String userType;
  final String? bio;
  final String deviceToken;
  dynamic profilePicture;

  // Constructor
  UserEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.userType,
    required this.deviceToken,
    this.profilePicture,
    this.bio,
  });
}

/// DANCER ENTITY
class DancerEntity extends UserEntity {
  final Map<String, dynamic>? jobPrefs;
  final Map<String, dynamic>? resume;

  // Constructor
  DancerEntity({
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.password,
    required super.phoneNumber,
    required super.userType,
    required super.deviceToken,
    this.jobPrefs,
    super.profilePicture,
    super.bio,
    this.resume,
  });

  @override
  String toString() {
    return 'DancerEntity(email: $email, userType: $userType)';
  }
}

/// CLIENT ENTITY
class ClientEntity extends UserEntity {
  final List<dynamic>? danceStylePrefs;
  List<dynamic>? jobOfferings;
  final String? organisationName;
  final Map<String, dynamic>? hiringHistory;

  // Constructor
  ClientEntity({
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.password,
    required super.userType,
    required super.deviceToken,
    this.danceStylePrefs,
    this.jobOfferings,
    super.profilePicture,
    super.bio,
    this.organisationName,
    this.hiringHistory,
  });

  @override
  String toString() {
    return 'ClientEntity(email: $email, organisationName: $organisationName, userType: $userType)';
  }
}

/// UITILITY CLASS ON USER ENTITY
extension UserEntityUtils on UserEntity {
  // This returns true is user is dancer
  bool get isDancer => this is DancerEntity;

  // Returns true if user is client
  bool get isClient => this is ClientEntity;

  // This returns user as DancerEntity if user is a dancer
  DancerEntity? get asDancer => isDancer ? this as DancerEntity : null;

  // This returns user as ClientEntity if user is a client
  ClientEntity? get asClient => isClient ? this as ClientEntity : null;

  // Returns true if the user is a dancer, if dance styles is a list and if it is not empty
  bool get hasDanceStyles =>
      asDancer?.jobPrefs!['danceStyles'] is List &&
      (asDancer?.jobPrefs!['danceStyles'] as List).isNotEmpty;

  // Returns true if user is a dancer, if job types is a list and if it is not empty
  bool get hasJobTypes =>
      asDancer?.jobPrefs!['jobTypes'] is List &&
      (asDancer?.jobPrefs!['jobTypes'] as List).isNotEmpty;

  // Returns true if user is a dancer, if job locations is a list and if it is not empty
  bool get hasJobLocations =>
      asDancer?.jobPrefs!['jobLocations'] is List &&
      (asDancer?.jobPrefs!['jobLocations'] as List).isNotEmpty;

  // Returns true if the user is dancer, if resume is a Map and if it is not empty
  bool get hasResume =>
      asDancer?.resume is Map && (asDancer?.resume as Map).isNotEmpty;

/**
 * DO SAME FOR CLIENT
 */

// Returns true if the user is a client, if dance style prefs is a list and if it is not empty
  bool get hasDanceStylePrefs =>
      asClient?.danceStylePrefs is List &&
      (asClient?.danceStylePrefs as List).isNotEmpty;

  // Returns true if user is a client, if job offerings is a list and if it is not empty
  bool get hasJobOfferings =>
      asClient?.jobOfferings is List &&
      (asClient?.jobOfferings as List).isNotEmpty;

  // This return true if user is a client, if hiriing history is map and if it is not empty
  bool get hasHiringHistory =>
      asClient?.hiringHistory is Map &&
      (asClient?.hiringHistory as Map).isNotEmpty;
}
