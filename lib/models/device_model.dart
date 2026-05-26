// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  List<Datum> data;

  AddressModel({required this.data});

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int id;
  String deviceCode;
  String qrCodeUrl;
  String name;
  String status;
  DateTime lastActive;
  int addressId;
  DateTime createdAt;
  DateTime updatedAt;
  Address address;

  Datum({
    required this.id,
    required this.deviceCode,
    required this.qrCodeUrl,
    required this.name,
    required this.status,
    required this.lastActive,
    required this.addressId,
    required this.createdAt,
    required this.updatedAt,
    required this.address,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    deviceCode: json["device_code"],
    qrCodeUrl: json["qr_code_url"],
    name: json["name"],
    status: json["status"],
    lastActive: DateTime.parse(json["last_active"]),
    addressId: json["address_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    address: Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "device_code": deviceCode,
    "qr_code_url": qrCodeUrl,
    "name": name,
    "status": status,
    "last_active": lastActive.toIso8601String(),
    "address_id": addressId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "address": address.toJson(),
  };
}

class Address {
  String name;
  String address;

  Address({required this.name, required this.address});

  factory Address.fromJson(Map<String, dynamic> json) =>
      Address(name: json["name"], address: json["address"]);

  Map<String, dynamic> toJson() => {"name": name, "address": address};
}
