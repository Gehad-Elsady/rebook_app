import 'package:dio/dio.dart';
import 'const.dart';

class PaymobManager {
  // Public method to get payment key
  Future<String> getPaymentKey(double amount, String currency) async {
    try {
      String authanticationToken = await _getAuthanticationToken();

      int orderId = await _getOrderId(
        authanticationToken: authanticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
      );

      String paymentKey = await _getPaymentKey(
        authanticationToken: authanticationToken,
        amount: (100 * amount).toString(),
        currency: currency,
        orderId: orderId.toString(),
      );

      return paymentKey;
    } catch (e) {
      print("❌ Exception in getPaymentKey:");
      print(e.toString());
      throw Exception("Failed to generate payment key.");
    }
  }

  // Retry POST requests in case of 429 errors
  Future<Response> _postWithRetry(String url, Map<String, dynamic> data) async {
    final Dio dio = Dio();
    int retryCount = 0;

    while (retryCount < 3) {
      try {
        final response = await dio.post(url, data: data);
        return response;
      } on DioException catch (e) {
        if (e.response?.statusCode == 429) {
          retryCount++;
          print("⚠️ Received 429 Too Many Requests. Retrying... [$retryCount]");
          await Future.delayed(Duration(seconds: 2));
          continue;
        }
        rethrow;
      }
    }

    throw Exception("Too many requests. Please try again later.");
  }

  // Get authentication token
  Future<String> _getAuthanticationToken() async {
    final response = await _postWithRetry(
      "https://accept.paymob.com/api/auth/tokens",
      {"api_key": KConstants().apiKey},
    );
    return response.data["token"];
  }

  // Create an order and get its ID
  Future<int> _getOrderId({
    required String authanticationToken,
    required String amount,
    required String currency,
  }) async {
    final response = await _postWithRetry(
      "https://accept.paymob.com/api/ecommerce/orders",
      {
        "auth_token": authanticationToken,
        "amount_cents": amount,
        "currency": currency,
        "delivery_needed": "false",
        "items": [],
      },
    );
    return response.data["id"];
  }

  // Get payment key from Paymob
  Future<String> _getPaymentKey({
    required String authanticationToken,
    required String orderId,
    required String amount,
    required String currency,
  }) async {
    final response = await _postWithRetry(
      "https://accept.paymob.com/api/acceptance/payment_keys",
      {
        "expiration": 3600,
        "auth_token": authanticationToken,
        "order_id": orderId,
        "integration_id": KConstants().cardPaymentMethodIntegrationId,
        "amount_cents": amount,
        "currency": currency,
        "billing_data": {
          "first_name": "Clifford",
          "last_name": "Nicolas",
          "email": "claudette09@exa.com",
          "phone_number": "+86(8)9135210487",
          "apartment": "NA",
          "floor": "NA",
          "street": "NA",
          "building": "NA",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "state": "NA"
        },
      },
    );
    return response.data["token"];
  }
}
