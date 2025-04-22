import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rebook_app/backend/firebase_functions.dart';
import 'package:rebook_app/notifications/model/notification_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyNotification {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await requestPermission();
    String? deviceToken = await getDeviceToken();
    if (deviceToken != null) {
      print("Device Token: $deviceToken");
    }
    await setupLocalNotifications();
    await getAccessToken();
    await saveUserToken();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  static Future<String?> getDeviceToken() async {
    try {
      String? token = await messaging.getToken();
      if (token == null) {
        print("Failed to fetch device token");
      }
      return token;
    } catch (e) {
      print("Error fetching device token: $e");
      return null;
    }
  }

  static Future<void> setupLocalNotifications() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
  }

  static Future<String?> getAccessToken() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        print("Access Token: $token");
        return token;
      } else {
        print("User is not logged in");
        return null;
      }
    } catch (e) {
      print("Error fetching access token: $e");
      return null;
    }
  }

  static Future<void> saveUserToken() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print("User is not logged in");
        return;
      }

      String? deviceToken = await getDeviceToken();
      String? accessToken = await getAccessToken();

      if (deviceToken != null && accessToken != null) {
        NotificationModel model = NotificationModel(
          id: userId,
          deviceToken: deviceToken,
          accessToken: accessToken,
        );
        await FirebaseFunctions.addDeviceTokens(model);
        print("Device token and access token saved successfully.");
      } else {
        print("Failed to save device token or access token");
      }
    } catch (e) {
      print("Error saving user token: $e");
    }
  }
}
