import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rebook_app/backend/firebase_functions.dart';
import 'package:rebook_app/notifications/notification_helper.dart';

class NotificationBack {
  // Get device token for the user
  static Future<String?> getDeviceToken(String userId) async {
    Stream<String?> stream = FirebaseFunctions.getUserDeviceTokenStream(userId);

    // Use await for to listen for the first result from the stream
    await for (var model in stream) {
      if (model != null) {
        // Return the device token from the model
        return model;
      } else {
        print("No notification data found.");
      }
      break; // Break after getting the first value, if you only need the first result.
    }
    return null; // Return null if no device token is found.
  }

  // Function to send notification using device token
  static Future<void> sendAcceptNotification(String userId) async {
    String? deviceToken = await getDeviceToken(userId);
    print(deviceToken);

    if (deviceToken != null) {
      final get = get_server_key();
      String token = await get.server_token();
      await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/app-app-4fb0a/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "message": {
            "token": deviceToken, // Use the fetched device token here
            "notification": {
              "body": 'Your order is accepted. you will receive the order soon',
              "title": 'Accepted Order',
            },
            "data": {"story_id": "story_12345"}
          }
        }),
      );
      print('Notification sent!');
    } else {
      print("No device token found, notification not sent.");
    }
  }

  static Future<void> sendDeclinedNotification(String userId) async {
    String? deviceToken = await getDeviceToken(userId);

    if (deviceToken != null) {
      final get = get_server_key();
      String token = await get.server_token();
      await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/app-app-4fb0a/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "message": {
            "token": deviceToken, // Use the fetched device token here
            "notification": {
              "body":
                  'Your order was Declined the order was to the Pending state ',
              "title": 'Declined Order',
            },
            "data": {"story_id": "story_12345"}
          }
        }),
      );
      print('Notification sent!');
    } else {
      print("No device token found, notification not sent.");
    }
  }

  static Future<void> sendPlacedOrderNotification(String userId) async {
    String? deviceToken = await getDeviceToken(userId);
    print(deviceToken);

    if (deviceToken != null) {
      final get = get_server_key();
      String token = await get.server_token();
      await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/app-app-4fb0a/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(<String, dynamic>{
          "message": {
            "token": deviceToken, // Use the fetched device token here
            "notification": {
              "body":
                  'A user has placed an order and his order has items you serve please accept it and deliver it to the user',
              "title": 'Order Placed',
            },
            "data": {"story_id": "story_12345"}
          }
        }),
      );
      print('Notification sent!');
    } else {
      print("No device token found, notification not sent.");
    }
  }
}
