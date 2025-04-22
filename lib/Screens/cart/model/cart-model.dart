import 'package:rebook_app/Screens/add-services/model/service-model.dart';

class CartModel {
  ServiceModel serviceModel;
  String userId;
  String? itemId;
  CartModel({required this.serviceModel, required this.userId, this.itemId});
  Map<String, dynamic> toMap() {
    return {
      'serviceModel': serviceModel.toJson(),
      'userId': userId,
      'itemId': itemId
    };
  }

  static CartModel fromMap(Map<String, dynamic> map) {
    return CartModel(
      serviceModel: ServiceModel.fromJson(map['serviceModel']),
      userId: map['userId'],
      itemId: map['itemId'],
    );
  }
}
