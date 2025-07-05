import 'package:rebook_app/Screens/add-services/model/service-model.dart';
import 'package:rebook_app/Screens/cart/model/cart-model.dart';
import 'package:rebook_app/location/model/locationmodel.dart';

class HistoryModel {
  String? id;
  List<CartModel>? items;
  String? userId;
  String? orderType;
  String? orderStatus;
  String? orderOwnerName;
  String? orderOwnerPhone;
  ServiceModel? serviceModel;
  LocationModel? locationModel;
  Map<String, dynamic>? shippingDetails;
  Map<String, dynamic>? paymentDetails;
  int? timestamp;
  DateTime? orderDate;
  DateTime? deliveryDate;
  String? trackingNumber;
  double? totalAmount;
  double? shippingFee;
  double? taxAmount;
  String? paymentStatus;
  String? deliveryStatus;
  String? notes;

  HistoryModel({
    this.id,
    this.items,
    this.userId,
    this.orderType,
    this.serviceModel,
    this.locationModel,
    this.shippingDetails,
    this.paymentDetails,
    this.timestamp,
    this.orderStatus = 'pending',
    this.orderOwnerName,
    this.orderOwnerPhone,
    this.orderDate,
    this.deliveryDate,
    this.trackingNumber,
    this.totalAmount,
    this.shippingFee = 0.0,
    this.taxAmount = 0.0,
    this.paymentStatus = 'unpaid',
    this.deliveryStatus = 'processing',
    this.notes,
  }) {
    orderDate ??= DateTime.now();
    timestamp ??= orderDate!.millisecondsSinceEpoch;
  }

  // Named constructor for deserialization
  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    items = (json['items'] as List<dynamic>?)
        ?.map((item) => CartModel.fromMap(item))
        .toList();
    userId = json['userId'] as String?;
    orderType = json['orderType'] as String?;
    orderStatus = json['orderStatus'] as String? ?? 'pending';
    orderOwnerName = json['orderOwnerName'] as String?;
    orderOwnerPhone = json['orderOwnerPhone'] as String?;
    shippingDetails = json['shippingDetails'] != null 
        ? Map<String, dynamic>.from(json['shippingDetails'] as Map)
        : null;
    paymentDetails = json['paymentDetails'] != null
        ? Map<String, dynamic>.from(json['paymentDetails'] as Map)
        : null;
    timestamp = json['timestamp'] as int?;
    orderDate = json['orderDate'] != null 
        ? DateTime.parse(json['orderDate'] as String)
        : null;
    deliveryDate = json['deliveryDate'] != null
        ? DateTime.parse(json['deliveryDate'] as String)
        : null;
    trackingNumber = json['trackingNumber'] as String?;
    totalAmount = (json['totalAmount'] as num?)?.toDouble();
    shippingFee = (json['shippingFee'] as num?)?.toDouble() ?? 0.0;
    taxAmount = (json['taxAmount'] as num?)?.toDouble() ?? 0.0;
    paymentStatus = json['paymentStatus'] as String? ?? 'unpaid';
    deliveryStatus = json['deliveryStatus'] as String? ?? 'processing';
    notes = json['notes'] as String?;
    userId = json['userId'] as String?;
    orderType = json['OrderType'] as String?;
    serviceModel = json['serviceModel'] != null
        ? ServiceModel.fromJson(json['serviceModel'])
        : null;
    locationModel = json['locationModel'] != null
        ? LocationModel.fromMap(json['locationModel'])
        : null;
    timestamp = json['timestamp'];
    orderStatus = json['orderStatus'] as String?;
    orderOwnerName = json['orderOwnerName'] as String?;
    orderOwnerPhone = json['orderOwnerPhone'] as String?;
  }

  // Method for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items?.map((item) => item.toMap()).toList(),
      'userId': userId,
      'orderType': orderType,
      'orderStatus': orderStatus,
      'orderOwnerName': orderOwnerName,
      'orderOwnerPhone': orderOwnerPhone,
      'shippingDetails': shippingDetails,
      'paymentDetails': paymentDetails,
      'timestamp': timestamp,
      'orderDate': orderDate?.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'totalAmount': totalAmount,
      'shippingFee': shippingFee,
      'taxAmount': taxAmount,
      'paymentStatus': paymentStatus,
      'deliveryStatus': deliveryStatus,
      'notes': notes,
    }..removeWhere((key, value) => value == null);
  }

  // Helper method to calculate the grand total
  double get grandTotal {
    final subtotal = totalAmount ?? 0.0;
    return subtotal + (shippingFee ?? 0.0) + (taxAmount ?? 0.0);
  }

  // Helper method to update the order status
  void updateStatus({
    String? status,
    String? paymentStatus,
    String? deliveryStatus,
    String? trackingNumber,
  }) {
    if (status != null) orderStatus = status;
    if (paymentStatus != null) this.paymentStatus = paymentStatus;
    if (deliveryStatus != null) this.deliveryStatus = deliveryStatus;
    if (trackingNumber != null) this.trackingNumber = trackingNumber;
  }

  // Helper method to add a note to the order
  void addNote(String note) {
    if (notes == null) {
      notes = note;
    } else {
      notes = '${notes!}\n$note';
    }
  }
}
