import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hyperpay_flutter/src/models/payment_method.dart';
import 'package:hyperpay_flutter/src/models/payment_sheet_appearance.dart';

/// Parameters for configuring the payment sheet
@immutable
class PaymentSheetParams {
  /// Creates a new payment sheet parameters configuration
  const PaymentSheetParams({
    required this.checkoutId,
    required this.amount,
    required this.currency,
    this.paymentMethod = HyperPayMethod.applePay,
    PaymentSheetAppearance? appearance,
    this.billingDetails,
    this.merchantDisplayName,
    this.customerId,
    this.testMode = false,
  }) : appearance = appearance ?? const PaymentSheetAppearance.light();

  /// Checkout ID from HyperPay
  final String checkoutId;

  /// Amount to charge
  final double amount;

  /// Currency code (e.g., 'SAR', 'USD')
  final String currency;

  /// Payment method to use
  final HyperPayMethod paymentMethod;

  /// Appearance configuration for the payment sheet
  final PaymentSheetAppearance appearance;

  /// Billing details for the payment
  final BillingDetails? billingDetails;

  /// Merchant name to display on the payment sheet
  final String? merchantDisplayName;

  /// Customer ID for saved payment methods
  final String? customerId;

  /// Whether to use test mode
  final bool testMode;

  /// Creates a copy of this configuration with the given fields replaced
  PaymentSheetParams copyWith({
    String? checkoutId,
    double? amount,
    String? currency,
    HyperPayMethod? paymentMethod,
    PaymentSheetAppearance? appearance,
    BillingDetails? billingDetails,
    String? merchantDisplayName,
    String? customerId,
    bool? testMode,
  }) {
    return PaymentSheetParams(
      checkoutId: checkoutId ?? this.checkoutId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      appearance: appearance ?? this.appearance,
      billingDetails: billingDetails ?? this.billingDetails,
      merchantDisplayName: merchantDisplayName ?? this.merchantDisplayName,
      customerId: customerId ?? this.customerId,
      testMode: testMode ?? this.testMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentSheetParams &&
        other.checkoutId == checkoutId &&
        other.amount == amount &&
        other.currency == currency &&
        other.paymentMethod == paymentMethod &&
        other.appearance == appearance &&
        other.billingDetails == billingDetails &&
        other.merchantDisplayName == merchantDisplayName &&
        other.customerId == customerId &&
        other.testMode == testMode;
  }

  @override
  int get hashCode {
    return Object.hash(
      checkoutId,
      amount,
      currency,
      paymentMethod,
      appearance,
      billingDetails,
      merchantDisplayName,
      customerId,
      testMode,
    );
  }
}

/// Billing details for the payment
@immutable
class BillingDetails {
  /// Creates new billing details
  const BillingDetails({
    this.name,
    this.email,
    this.phone,
    this.address,
  });

  /// Customer name
  final String? name;

  /// Customer email
  final String? email;

  /// Customer phone number
  final String? phone;

  /// Customer address
  final Address? address;

  /// Creates a copy of this billing details with the given fields replaced
  BillingDetails copyWith({
    String? name,
    String? email,
    String? phone,
    Address? address,
  }) {
    return BillingDetails(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BillingDetails &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.address == address;
  }

  @override
  int get hashCode => Object.hash(name, email, phone, address);

  /// Converts the billing details to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address?.toMap(),
    }..removeWhere((key, value) => value == null);
  }
}

/// Address details
@immutable
class Address {
  /// Creates a new address
  const Address({
    this.line1,
    this.line2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });

  /// Address line 1
  final String? line1;

  /// Address line 2
  final String? line2;

  /// City
  final String? city;

  /// State/Province
  final String? state;

  /// Postal/ZIP code
  final String? postalCode;

  /// Country code (ISO 3166-1 alpha-2)
  final String? country;

  /// Creates a copy of this address with the given fields replaced
  Address copyWith({
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
  }) {
    return Address(
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Address &&
        other.line1 == line1 &&
        other.line2 == line2 &&
        other.city == city &&
        other.state == state &&
        other.postalCode == postalCode &&
        other.country == country;
  }

  @override
  int get hashCode {
    return Object.hash(
      line1,
      line2,
      city,
      state,
      postalCode,
      country,
    );
  }

  /// Converts the address to a map
  Map<String, dynamic> toMap() {
    return {
      'line1': line1,
      'line2': line2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': country,
    }..removeWhere((key, value) => value == null);
  }
}
