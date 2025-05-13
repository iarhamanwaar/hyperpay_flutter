import 'package:flutter/foundation.dart';

/// Available payment methods
enum PaymentMethod {
  /// Apple Pay payment method
  applePay,

  /// Credit Card payment method
  card,

  /// MADA debit card payment method
  mada,
}

/// Payment method types supported by HyperPay
enum HyperPayMethod {
  /// Apple Pay payment method
  applePay,

  /// Credit/Debit card payment method
  card,

  /// STC Pay payment method (Saudi Arabia)
  stcPay,
}

/// Brand of the payment card
enum CardBrand {
  /// Visa card
  visa,

  /// Mastercard
  mastercard,

  /// Mada card (Saudi Arabia)
  mada,

  /// Unknown card brand
  unknown,
}

/// Card details for payment
@immutable
class CardDetails {
  /// Creates a new card details object
  const CardDetails({
    required this.number,
    required this.expiryMonth,
    required this.expiryYear,
    required this.cvc,
    required this.holderName,
    this.brand = CardBrand.unknown,
  });

  /// Card number
  final String number;

  /// Card expiry month (1-12)
  final int expiryMonth;

  /// Card expiry year (YYYY)
  final int expiryYear;

  /// Card CVC/CVV
  final String cvc;

  /// Card holder name
  final String holderName;

  /// Card brand (Visa, Mastercard, etc.)
  final CardBrand brand;

  /// Creates a copy of this card details with the given fields
  /// replaced with new values
  CardDetails copyWith({
    String? number,
    int? expiryMonth,
    int? expiryYear,
    String? cvc,
    String? holderName,
    CardBrand? brand,
  }) {
    return CardDetails(
      number: number ?? this.number,
      expiryMonth: expiryMonth ?? this.expiryMonth,
      expiryYear: expiryYear ?? this.expiryYear,
      cvc: cvc ?? this.cvc,
      holderName: holderName ?? this.holderName,
      brand: brand ?? this.brand,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CardDetails &&
        other.number == number &&
        other.expiryMonth == expiryMonth &&
        other.expiryYear == expiryYear &&
        other.cvc == cvc &&
        other.holderName == holderName &&
        other.brand == brand;
  }

  @override
  int get hashCode {
    return Object.hash(
      number,
      expiryMonth,
      expiryYear,
      cvc,
      holderName,
      brand,
    );
  }

  /// Converts the card details to a map
  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'expiryMonth': expiryMonth,
      'expiryYear': expiryYear,
      'cvc': cvc,
      'holderName': holderName,
      'brand': brand.toString().split('.').last,
    };
  }
}
