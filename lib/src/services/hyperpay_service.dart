import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hyperpay_flutter/src/models/hyperpay_config.dart';

/// Service for handling HyperPay API calls
class HyperPayService {
  /// Creates a new HyperPay service
  const HyperPayService({required this.config});

  /// The configuration for the service
  final HyperPayConfig config;

  /// Creates a checkout ID for HyperPay payment
  Future<String> createCheckoutId({
    required double amount,
    required String currency,
    String paymentType = 'DB',
  }) async {
    try {
      final uri = Uri.https(
        config.environment.baseUrl,
        '/v1/checkouts',
      );

      final requestBody = {
        'entityId': config.entityId,
        'amount': amount.toStringAsFixed(2),
        'currency': currency,
        'paymentType': paymentType,
      };

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': 'Bearer ${config.authToken}',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;
        final checkoutId = responseData['id'] as String?;
        final result = responseData['result'] as Map<String, dynamic>?;

        if (result?['code'] == '000.200.100' && checkoutId != null) {
          return checkoutId;
        } else {
          throw HyperPayException(
            result?['description']?.toString() ??
                'Failed to create checkout ID',
          );
        }
      } else {
        throw HyperPayException(
          'Failed to create checkout ID: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is HyperPayException) rethrow;
      throw HyperPayException('Failed to create checkout ID: $e');
    }
  }
}

/// Exception thrown when a HyperPay operation fails
class HyperPayException implements Exception {
  /// Creates a new HyperPay exception
  const HyperPayException(this.message);

  /// The error message
  final String message;

  @override
  String toString() => 'HyperPayException: $message';
}
