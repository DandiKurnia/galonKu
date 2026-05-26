class TransactionDetailModel {
  final TransactionDetailData data;

  TransactionDetailModel({required this.data});

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      TransactionDetailModel(
        data: TransactionDetailData.fromJson(
          json['data'] as Map<String, dynamic>,
        ),
      );
}

class TransactionDetailData {
  final int id;
  final int totalGalon;
  final int totalPrice;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final PaymentDetail? payment;
  final UserDetail? user;
  final DeviceDetail? device;
  final List<TransactionLine> transactionDetails;
  final List<TransactionHistory> transactionHistories;
  final List<WaterFillLog> waterFillLogs;

  TransactionDetailData({
    required this.id,
    required this.totalGalon,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.payment,
    required this.user,
    required this.device,
    required this.transactionDetails,
    required this.transactionHistories,
    required this.waterFillLogs,
  });

  factory TransactionDetailData.fromJson(Map<String, dynamic> json) =>
      TransactionDetailData(
        id: json['id'] ?? 0,
        totalGalon: json['total_galon'] ?? 0,
        totalPrice: json['total_price'] ?? 0,
        status: json['status'] ?? '',
        createdAt: _parseDate(json['created_at']),
        updatedAt: _parseDate(json['updated_at']),
        payment: json['payment'] is Map<String, dynamic>
            ? PaymentDetail.fromJson(json['payment'])
            : null,
        user: json['user'] is Map<String, dynamic>
            ? UserDetail.fromJson(json['user'])
            : null,
        device: json['device'] is Map<String, dynamic>
            ? DeviceDetail.fromJson(json['device'])
            : null,
        transactionDetails: (json['transaction_details'] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(TransactionLine.fromJson)
                .toList() ??
            const [],
        transactionHistories: (json['transaction_histories'] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(TransactionHistory.fromJson)
                .toList() ??
            const [],
        waterFillLogs: (json['water_fill_logs'] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(WaterFillLog.fromJson)
                .toList() ??
            const [],
      );
}

class PaymentDetail {
  final int id;
  final String status;
  final String paymentMethod;
  final String? invoiceUrl;
  final DateTime? expiryDate;

  PaymentDetail({
    required this.id,
    required this.status,
    required this.paymentMethod,
    required this.invoiceUrl,
    required this.expiryDate,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        id: json['id'] ?? 0,
        status: json['status'] ?? '',
        paymentMethod: json['payment_method'] ?? '',
        invoiceUrl: json['invoice_url'] as String?,
        expiryDate: json['expiry_date'] != null
            ? DateTime.tryParse(json['expiry_date'])
            : null,
      );
}

class UserDetail {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;

  UserDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phone_number'] as String?,
      );
}

class DeviceDetail {
  final int id;
  final String name;
  final String status;
  final AddressDetail? address;

  DeviceDetail({
    required this.id,
    required this.name,
    required this.status,
    required this.address,
  });

  factory DeviceDetail.fromJson(Map<String, dynamic> json) => DeviceDetail(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        status: json['status'] ?? '',
        address: json['address'] is Map<String, dynamic>
            ? AddressDetail.fromJson(json['address'])
            : null,
      );
}

class AddressDetail {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  AddressDetail({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory AddressDetail.fromJson(Map<String, dynamic> json) => AddressDetail(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        address: json['address'] ?? '',
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
      );
}

class TransactionLine {
  final int id;
  final int galonQty;
  final int priceOneGalon;
  final int subTotal;

  TransactionLine({
    required this.id,
    required this.galonQty,
    required this.priceOneGalon,
    required this.subTotal,
  });

  factory TransactionLine.fromJson(Map<String, dynamic> json) =>
      TransactionLine(
        id: json['id'] ?? 0,
        galonQty: json['galon_qty'] ?? 0,
        priceOneGalon: json['price_one_galon'] ?? 0,
        subTotal: json['sub_total'] ?? 0,
      );
}

class TransactionHistory {
  final int id;
  final String status;
  final String description;
  final DateTime createdAt;

  TransactionHistory({
    required this.id,
    required this.status,
    required this.description,
    required this.createdAt,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        id: json['id'] ?? 0,
        status: json['status'] ?? '',
        description: json['description'] ?? '',
        createdAt: _parseDate(json['created_at']),
      );
}

class WaterFillLog {
  final int id;
  final int galonNumber;
  final DateTime createdAt;

  WaterFillLog({
    required this.id,
    required this.galonNumber,
    required this.createdAt,
  });

  factory WaterFillLog.fromJson(Map<String, dynamic> json) => WaterFillLog(
        id: json['id'] ?? 0,
        galonNumber: json['galon_number'] ?? 0,
        createdAt: _parseDate(json['created_at']),
      );
}

DateTime _parseDate(dynamic raw) {
  if (raw is String) {
    return DateTime.tryParse(raw) ??
        DateTime.fromMillisecondsSinceEpoch(0);
  }
  return DateTime.fromMillisecondsSinceEpoch(0);
}
