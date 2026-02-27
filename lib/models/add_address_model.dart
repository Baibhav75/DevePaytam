// // class AddAddressModel {
// //   final int userId;
// //   final String name;
// //   final String mobileNo;
// //   final String addressType;
// //   final String address;
// //   final String city;
// //   final String state;
// //   final String pinCode;
// //   final String createdDate;
// //
// //   AddAddressModel({
// //     required this.userId,
// //     required this.name,
// //     required this.mobileNo,
// //     required this.addressType,
// //     required this.address,
// //     required this.city,
// //     required this.state,
// //     required this.pinCode,
// //     required this.createdDate,
// //   });
// //
// //   factory AddAddressModel.fromJson(Map<String, dynamic> json) {
// //     return AddAddressModel(
// //       userId: json['UserId'] ?? 0,
// //       name: json['Name'] ?? "",
// //       mobileNo: json['MobileNo'] ?? "",
// //       addressType: json['AddressType'] ?? "",
// //       address: json['Address'] ?? "",
// //       city: json['City'] ?? "",
// //       state: json['State'] ?? "",
// //       pinCode: json['PinCode'] ?? "",
// //       createdDate: json['CreatedDate'] ?? "",
// //     );
// //   }
// // }
//
// class AddAddressModel {
//   final int id;        // ✅ ADD THIS
//   final int userId;
//   final String name;
//   final String mobileNo;
//   final String addressType;
//   final String address;
//   final String city;
//   final String state;
//   final String pinCode;
//   final String createdDate;
//
//   AddAddressModel({
//     required this.id,   // ✅ ADD
//     required this.userId,
//     required this.name,
//     required this.mobileNo,
//     required this.addressType,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.pinCode,
//     required this.createdDate,
//   });
//
//   factory AddAddressModel.fromJson(Map<String, dynamic> json) {
//     return AddAddressModel(
//       id: json['Id'] ?? 0,   // ✅ CHECK API FIELD NAME
//       userId: json['UserId'] ?? 0,
//       name: json['Name'] ?? "",
//       mobileNo: json['MobileNo'] ?? "",
//       addressType: json['AddressType'] ?? "",
//       address: json['Address'] ?? "",
//       city: json['City'] ?? "",
//       state: json['State'] ?? "",
//       pinCode: json['PinCode'] ?? "",
//       createdDate: json['CreatedDate'] ?? "",
//     );
//   }
// }

class AddAddressModel {
  final int addressId;   // 🔥 rename properly
  final String name;
  final String mobileNo;
  final String addressType;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String createdDate;

  AddAddressModel({
    required this.addressId,
    required this.name,
    required this.mobileNo,
    required this.addressType,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.createdDate,
  });

  factory AddAddressModel.fromJson(Map<String, dynamic> json) {
    return AddAddressModel(
      addressId: json['UserId'] ?? 0,  // 🔥 this is address id
      name: json['Name'] ?? "",
      mobileNo: json['MobileNo'] ?? "",
      addressType: json['AddressType'] ?? "",
      address: json['Address'] ?? "",
      city: json['City'] ?? "",
      state: json['State'] ?? "",
      pinCode: json['PinCode'] ?? "",
      createdDate: json['CreatedDate'] ?? "",
    );
  }
}