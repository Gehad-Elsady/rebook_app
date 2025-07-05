import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rebook_app/Screens/add-services/model/service-model.dart';
import 'package:rebook_app/Screens/cart/cart-screen.dart';
import 'package:rebook_app/Screens/history/historyscreen.dart';
import 'package:rebook_app/Screens/history/model/historymaodel.dart';
import 'package:rebook_app/Screens/home/home-screen.dart';
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
            crossPlatform: InAppWebViewOptions(javaScriptEnabled: true)),
        onWebViewCreated: (controller) {
          _webViewController = controller;
          PaymobManager()
              .getPaymentKey(totalPrice, "EGP")
              .then((String paymentKey) {
            _webViewController?.loadUrl(
              urlRequest: URLRequest(
                url: WebUri(
                  "https://accept.paymob.com/api/acceptance/iframes/915260?payment_token=$paymentKey",
                ),
              ),
            );
          });
        },
        onLoadStop: (controller, url) {
          if (url != null && url.queryParameters.containsKey('success')) {
            if (url.queryParameters['success'] == 'true') {
              FirebaseFunctions.orderHistory(historymaodel!);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Payment Done"),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        },
                      ),
                    ],
                  );
                },
              );
              print("Payment Done");
            } else if (url.queryParameters['success'] == 'false') {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Payment Failed"),
                    actions: [
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.pushNamed(context, CartScreen.routeName);
                        },
                      ),
                    ],
                  );
                },
              );
              print("Payment Failed");
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        title: Text("Payment Canceled"),
                        actions: [
                          TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, CartScreen.routeName);
                              })
                        ]);
                  });
            }
          }
        },
      ),
    );
  }
}
