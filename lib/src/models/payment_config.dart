import 'package:flutter/foundation.dart';

/// Environment for HyperPay payments
enum HyperPayEnvironment {
  /// Test environment for development and testing
  test,

  /// Production environment for live payments
  production,
}

/// Configuration for HyperPay payments
@immutable
class HyperPayConfig {
  /// Creates a new HyperPay configuration
  const HyperPayConfig({
    required this.merchantIdentifier,
    required this.environment,
    required this.companyName,
    this.countryCode = 'SA',
    this.supportedNetworks = const ['mada', 'visa', 'masterCard'],
  });

  /// Your Apple Pay merchant identifier (e.g., "merchant.com.your.app")
  final String merchantIdentifier;

  /// Environment for the payment (test or production)
  final HyperPayEnvironment environment;

  /// Your company name that will appear on payment sheets
  final String companyName;

  /// Country code for payments (default: 'SA' for Saudi Arabia)
  final String countryCode;

  /// List of supported payment networks
  final List<String> supportedNetworks;

  /// Creates a copy of this configuration with the given fields
  /// replaced with new values
  HyperPayConfig copyWith({
    String? merchantIdentifier,
    HyperPayEnvironment? environment,
    String? companyName,
    String? countryCode,
    List<String>? supportedNetworks,
  }) {
    return HyperPayConfig(
      merchantIdentifier: merchantIdentifier ?? this.merchantIdentifier,
      environment: environment ?? this.environment,
      companyName: companyName ?? this.companyName,
      countryCode: countryCode ?? this.countryCode,
      supportedNetworks: supportedNetworks ?? this.supportedNetworks,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HyperPayConfig &&
        other.merchantIdentifier == merchantIdentifier &&
        other.environment == environment &&
        other.companyName == companyName &&
        other.countryCode == countryCode &&
        listEquals(other.supportedNetworks, supportedNetworks);
  }

  @override
  int get hashCode {
    return Object.hash(
      merchantIdentifier,
      environment,
      companyName,
      countryCode,
      Object.hashAll(supportedNetworks),
    );
  }
}
