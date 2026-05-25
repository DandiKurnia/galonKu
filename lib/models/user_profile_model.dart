// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String message;
  Data data;

  ProfileModel({required this.message, required this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      ProfileModel(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int id;
  String email;
  String name;
  String? avatar;
  String? phoneNumber;

  Data({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phoneNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    avatar: json["avatar"],
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "avatar": avatar,
    "phone_number": phoneNumber,
  };
}
