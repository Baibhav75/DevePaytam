class ProfileUpdateResponse {
  final bool status;
  final String message;
  final ProfileData? data;

  ProfileUpdateResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      status: json['Status'] ?? false,
      message: json['Message'] ?? '',
      data: json['Data'] != null
          ? ProfileData.fromJson(json['Data'])
          : null,
    );
  }
}

class ProfileData {
  final int userId;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String? profileImage;
  final String updatedAt;

  ProfileData({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    this.profileImage,
    required this.updatedAt,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      userId: json['UserId'],
      fullName: json['FullName'],
      email: json['Email'],
      mobileNumber: json['MobileNumber'],
      profileImage: json['ProfileImage'],
      updatedAt: json['UpdatedAt'],
    );
  }
}
