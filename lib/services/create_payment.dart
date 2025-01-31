import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> createPaymentIntent(int amount, String currency) async {
  final url = Uri.parse(dotenv.env['PAYMENT_INTENT_URL']!); // Fetch from .env

  try {
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': amount, // Amount in cents (e.g., $10.00 = 1000)
        'currency': currency, // Currency code (e.g., 'usd')
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['clientSecret']; // Stripe clientSecret
    } else {
      print('Failed to create Payment Intent: ${response.body}');
      return null;
    }
  } catch (e) {
    print('Error creating Payment Intent: $e');
    return null;
  }
}
