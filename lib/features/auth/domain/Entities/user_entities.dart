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

  // Constructor
  UserEntity({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });
}

/// DANCER ENTITY
class DancerEntity extends UserEntity {
  final List<dynamic> danceStyles;
  final dynamic portfolio;

  // Constructor
  DancerEntity({
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.password,
    required super.phoneNumber,
    required this.danceStyles,
    required this.portfolio,
  });
}

/// CLIENT ENTITY
class ClientEntity extends UserEntity {
  final String organisationName;

  // Constructor
  ClientEntity({
    required super.firstName,
    required super.lastName,
    required super.username,
    required super.email,
    required super.phoneNumber,
    required super.password,
    required this.organisationName,
  });
}
