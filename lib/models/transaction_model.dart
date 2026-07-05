// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) =>
    TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) =>
    json.encode(data.toJson());

class TransactionModel {
  List<Datum> data;
  Meta? meta;

  TransactionModel({required this.data, this.meta});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final rawData = json["data"];
    print('TransactionModel.fromJson: rawData type is ${rawData.runtimeType}');
    if (rawData is Map<String, dynamic>) {
      print('TransactionModel.fromJson: meta is ${rawData["meta"]}');
      return TransactionModel(
        data: List<Datum>.from(
          (rawData["items"] as List? ?? []).map((x) => Datum.fromJson(x)),
        ),
        meta: rawData["meta"] != null ? Meta.fromJson(rawData["meta"]) : null,
      );
    }
    return TransactionModel(
      data: List<Datum>.from(
        (rawData as List? ?? []).map((x) => Datum.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    "data": meta != null
        ? {
            "items": List<dynamic>.from(data.map((x) => x.toJson())),
            "meta": meta!.toJson(),
          }
        : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Meta {
  int total;
  int page;
  int limit;
  int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"] ?? 0,
        page: json["page"] ?? 1,
        limit: json["limit"] ?? 10,
        totalPages: json["total_pages"] ?? json["totalPages"] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "page": page,
        "limit": limit,
        "total_pages": totalPages,
      };
}

class Datum {
  int id;
  int deviceId;
  int userId;
  int totalGalon;
  int totalPrice;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  Payment? payment;
  Device? user;
  Device? device;

  Datum({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.totalGalon,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.payment,
    required this.user,
    required this.device,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] ?? 0,
    deviceId: json["device_id"] ?? 0,
    userId: json["user_id"] ?? 0,
    totalGalon: json["total_galon"] ?? 0,
    totalPrice: json["total_price"] ?? 0,
    status: json["status"] ?? '',
    createdAt: json["created_at"] != null
        ? DateTime.parse(json["created_at"])
        : DateTime.fromMillisecondsSinceEpoch(0),
    updatedAt: json["updated_at"] != null
        ? DateTime.parse(json["updated_at"])
        : DateTime.fromMillisecondsSinceEpoch(0),
    payment: json["payment"] is Map<String, dynamic>
        ? Payment.fromJson(json["payment"])
        : null,
    user: json["user"] is Map<String, dynamic>
        ? Device.fromJson(json["user"])
        : null,
    device: json["device"] is Map<String, dynamic>
        ? Device.fromJson(json["device"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "device_id": deviceId,
    "user_id": userId,
    "total_galon": totalGalon,
    "total_price": totalPrice,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "payment": payment?.toJson(),
    "user": user?.toJson(),
    "device": device?.toJson(),
  };
}

class Device {
  String name;

  Device({required this.name});

  factory Device.fromJson(Map<String, dynamic> json) =>
      Device(name: json["name"] ?? '');

  Map<String, dynamic> toJson() => {"name": name};
}

class Payment {
  String status;

  Payment({required this.status});

  factory Payment.fromJson(Map<String, dynamic> json) =>
      Payment(status: json["status"] ?? '');

  Map<String, dynamic> toJson() => {"status": status};
}
