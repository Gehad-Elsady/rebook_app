// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rebook_app/Screens/add-services/model/service-model.dart';
import 'package:rebook_app/Screens/cart/cart-screen.dart';
import 'package:rebook_app/Screens/cart/model/cart-model.dart';
import 'package:rebook_app/Screens/history/historyscreen.dart';
import 'package:rebook_app/Screens/history/model/historymaodel.dart';
import 'package:rebook_app/backend/firebase_functions.dart';
import 'package:rebook_app/paymob/paymob_manager.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen(
      {super.key, required this.totalPrice, required this.historymaodel});
  InAppWebViewController? _webViewController;
  final double totalPrice;
  HistoryModel? historymaodel;
  ServiceModel? serviceModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Screen'),
      ),
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(javaScriptEnabled: true),
        ),
        onWebViewCreated: (controller) async {
          _webViewController = controller;

          try {
            final paymentKey =
                await PaymobManager().getPaymentKey(totalPrice, "EGP");

            _webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(
                    "https://accept.paymob.com/api/acceptance/iframes/915260?payment_token=$paymentKey"),
              ),
            );
          } catch (e) {
            _showErrorDialog(context, "Error while initializing payment.");
          }
        },
        onLoadStop: (controller, url) {
          if (url == null || !url.queryParameters.containsKey('success'))
            return;

          final success = url.queryParameters['success'];

          if (success == 'true') {
            _handlePaymentSuccess(context);
          } else if (success == 'false') {
            _showErrorDialog(context, "Payment Failed",
                redirectTo: CartScreen.routeName);
          } else {
            _showErrorDialog(context, "Payment Canceled",
                redirectTo: CartScreen.routeName);
          }
        },
      ),
    );
  }

  void _handlePaymentSuccess(BuildContext context) {
    FirebaseFunctions.orderHistory(historymaodel!);

    final List<CartModel>? items = historymaodel?.items;
    for (final item in items ?? []) {
      // NotificationBack.sendPlacedOrderNotification(item.userId!);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("✅ Payment Done"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pushNamed(context, HistoryScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message,
      {String? redirectTo}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              if (redirectTo != null) {
                Navigator.pushNamed(context, redirectTo);
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
