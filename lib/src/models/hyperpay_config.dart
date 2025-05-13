import 'package:hyperpay_flutter/src/models/environment.dart';

/// Configuration for HyperPay SDK
class HyperPayConfig {
  /// Creates a new HyperPay configuration
  const HyperPayConfig({
    required this.merchantIdentifier,
    required this.environment,
    required this.companyName,
    required this.authToken,
    required this.entityId,
  });

  /// Creates a production configuration
  factory HyperPayConfig.production({
    required String merchantIdentifier,
    required String companyName,
    required String authToken,
    required String entityId,
  }) =>
      HyperPayConfig(
        merchantIdentifier: merchantIdentifier,
        environment: Environment.live,
        companyName: companyName,
        authToken: authToken,
        entityId: entityId,
      );

  /// Creates a test configuration
  factory HyperPayConfig.test({
    required String merchantIdentifier,
    required String companyName,
    required String authToken,
    required String entityId,
  }) =>
      HyperPayConfig(
        merchantIdentifier: merchantIdentifier,
        environment: Environment.test,
        companyName: companyName,
        authToken: authToken,
        entityId: entityId,
      );

  /// The merchant identifier from HyperPay
  final String merchantIdentifier;

  /// The environment to use (test or production)
  final Environment environment;

  /// Your company name that appears in payment sheets
  final String companyName;

  /// The authorization token for API calls
  final String authToken;

  /// The entity ID for the payment method
  final String entityId;

  @override
  String toString() => 'HyperPayConfig('
      'merchantIdentifier: $merchantIdentifier, '
      'environment: ${environment.name}, '
      'companyName: $companyName)';
}
