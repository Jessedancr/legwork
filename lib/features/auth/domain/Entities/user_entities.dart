/**
 * BASE ENTITY FOR USER
 */
abstract class UserEntity {
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final int phoneNumber;
  final String password;
  final String userType;
  final String? bio;
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
    this.profilePicture,
    this.bio,
  });

  //UserType get userType;
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
    this.jobPrefs,
    super.profilePicture,
    super.bio,
    this.resume,
  });

  // @override
  // UserType get userType => UserType.dancer;

  @override
  String toString() {
    return 'DancerEntity(email: $email, userType: $userType)';
  }
}

/// CLIENT ENTITY
class ClientEntity extends UserEntity {
  final List<dynamic> danceStylePrefs;
  final List<dynamic> jobOfferings;
  final String? organisationName;
  final Map<String, dynamic>? hiringHistory;

  // Constructor
  ClientEntity(
      {required super.firstName,
      required super.lastName,
      required super.username,
      required super.email,
      required super.phoneNumber,
      required super.password,
      required super.userType,
      required this.danceStylePrefs,
      required this.jobOfferings,
      super.profilePicture,
      super.bio,
      this.organisationName,
      this.hiringHistory});

  // @override
  // UserType get userType => UserType.client;

  @override
  String toString() {
    return 'ClientEntity(email: $email, organisationName: $organisationName, userType: $userType)';
  }
}
