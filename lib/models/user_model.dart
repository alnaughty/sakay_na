class UserModel {
  final int id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final DateTime? birthDate;
  final String? address;
  final String email;
  final String? accountType;
  final String? licenseNumber;
  final bool hasBooking;
  final String mobileNumber;
  final bool isEmailVerified;
  final bool isNumberVerified;
  final bool isAccountVerified;
  final int status;
  final int? totalTrips;
  final int? rating;
  final String? document;
  final String? avatarUrl;
  final int? vehicleId;

  const UserModel({
    required this.id,
    required this.firstName,
    this.middleName,
    this.hasBooking = false,
    required this.lastName,
    this.birthDate,
    this.address,
    required this.email,
    this.accountType,
    this.licenseNumber,
    required this.mobileNumber,
    required this.isEmailVerified,
    required this.isNumberVerified,
    required this.isAccountVerified,
    required this.status,
    this.totalTrips,
    this.rating,
    this.document,
    this.avatarUrl,
    this.vehicleId,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: int.parse(json["id"].toString()),
        firstName: json['first_name'],
        middleName: json['middle_name'],
        lastName: json['last_name'],
        birthDate: json['birth_date'] == null
            ? null
            : DateTime.parse(json['birth_date'].toString()),
        address: json['address'],
        email: json['email'],
        accountType: json['account_type'],
        licenseNumber: json['license_number'],
        mobileNumber: json['mobile_number'],
        isEmailVerified: int.parse(json['email_verified'].toString()) == 1,
        isNumberVerified: int.parse(json['number_verified'].toString()) == 1,
        isAccountVerified: int.parse(json['account_verified'].toString()) == 1,
        status: int.parse(json['active_status'].toString()),
        totalTrips: json['total_trip'] == null
            ? null
            : int.parse(json['total_trip'].toString()),
        rating: json['rating'] == null
            ? null
            : int.parse(json['rating'].toString()),
        document: json['documents'],
        avatarUrl: json['photo'],
        vehicleId: json['vehicle_id'] != null
            ? int.parse(json['vehicle_id'].toString())
            : null,
        hasBooking: json['active_status'] == null
            ? false
            : int.parse(json['active_status'].toString()) == 1,
      );
}
