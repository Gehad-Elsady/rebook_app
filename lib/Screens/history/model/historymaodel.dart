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
  int? timestamp;

  HistoryModel({
    this.id,
    this.items,
    this.userId,
    this.orderType,
    this.serviceModel,
    this.locationModel,
    this.timestamp,
    this.orderStatus,
    this.orderOwnerName,
    this.orderOwnerPhone,
  });

  // Named constructor for deserialization
  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    items = (json['items'] as List<dynamic>?)
        ?.map((item) => CartModel.fromMap(item))
        .toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['items'] = items?.map((item) => item.toMap()).toList();
    data['userId'] = userId;
    data['OrderType'] = orderType;
    data['serviceModel'] = serviceModel?.toJson();
    data['locationModel'] = locationModel?.toMap();
    data['timestamp'] = timestamp;
    data['orderStatus'] = orderStatus;
    data['orderOwnerName'] = orderOwnerName;
    data['orderOwnerPhone'] = orderOwnerPhone;
    return data;
  }
}
