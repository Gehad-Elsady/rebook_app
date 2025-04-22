class NotificationModel {
  String id;
  String deviceToken;
  String accessToken;

  NotificationModel(
      {required this.id, required this.deviceToken, required this.accessToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deviceToken'] = deviceToken;
    data['accessToken'] = accessToken;
    return data;
  }

  static NotificationModel fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'],
        deviceToken: json['deviceToken'],
        accessToken: json['accessToken']);
  }
}
