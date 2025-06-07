class UserProfile {
  final String firstName;
  final String lastName;
  final String email;
  final String city;
  final String phoneNumber;
  final String district;
  final String roleName;
  final String roleId;
  final String? profileImageUrl;
  final String? profileCoverUrl;
  final num? totalBalance;

  UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.city,
    required this.phoneNumber,
    required this.district,
    required this.roleName,
    required this.roleId,
    this.profileImageUrl,
    this.profileCoverUrl,
    this.totalBalance,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['FirstName'] ?? '',
      lastName: json['LastName'] ?? '',
      email: json['Email'] ?? '',
      city: json['City'] ?? '',
      phoneNumber: json['PhoneNumber'] ?? '',
      district: json['District'] ?? '',
      roleName: json['RoleName'] ?? '',
      roleId: json['RoleId'] ?? '',
      profileImageUrl: json['ProfileImageUrl'] ?? '',
      profileCoverUrl: json['ProfileCoverUrl'] ?? '',
      totalBalance: json['TotalBalance'],
    );
  }

  @override
  String toString() {
    return "firstName: $firstName, lastName: $lastName, email: $email, city: $city, phoneNumber: $phoneNumber, district: $district, roleName: $roleName, roleId: $roleId, profileImageUrl: $profileImageUrl, profileCoverUrl: $profileCoverUrl, totalBalance: $totalBalance";
  }
}
