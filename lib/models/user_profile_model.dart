class UserProfileResponse {
  final bool status;
  final String message;
  final UserProfile data;

  UserProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json['Status'],
      message: json['Message'],
      data: UserProfile.fromJson(json['Data']),
    );
  }
}

class UserProfile {
  final int userId;
  final String fullName;
  final String mobileNumber;
  final String email;
  final bool isMobileVerified;
  final String createdAt;
  final String updatedAt;

  UserProfile({
    required this.userId,
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.isMobileVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['UserId'],
      fullName: json['FullName'] ?? '',
      mobileNumber: json['MobileNumber'] ?? '',
      email: json['Email'] ?? '',
      isMobileVerified: json['IsMobileVerified'] ?? false,
      createdAt: json['CreatedAt'] ?? '',
      updatedAt: json['UpdatedAt'] ?? '',
    );
  }
}
