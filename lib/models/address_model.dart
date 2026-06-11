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
  String name;
  String address;
  double latitude;
  double longitude;
  DateTime createdAt;
  DateTime updatedAt;
  List<Device> devices;

  Datum({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.devices,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"] ?? '',
    address: json["address"] ?? '',
    latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
    longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    devices: json["devices"] == null
        ? []
        : List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
  };
}

class Device {
  String name;
  String status;

  Device({required this.name, required this.status});

  factory Device.fromJson(Map<String, dynamic> json) =>
      Device(name: json["name"] ?? '', status: json["status"] ?? '');

  Map<String, dynamic> toJson() => {"name": name, "status": status};
}
