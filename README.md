# HyperPay Flutter

[![pub package](https://img.shields.io/pub/v/hyperpay_flutter.svg)](https://pub.dev/packages/hyperpay_flutter)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter plugin for integrating HyperPay payment gateway with enhanced features including Apple Pay and card payments.

## Features

- 💳 Credit Card Payments
- 🏦 MADA Support
- 🍎 Apple Pay Integration
- 🔄 Automatic Checkout ID Creation
- 🎨 Beautiful UI Components
- ✨ Type-safe API
- 🔒 Secure Payment Processing
- 📱 Example App Included

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  hyperpay_flutter: ^0.1.0+1
```

## Usage

### Initialize HyperPay

```dart
await HyperPay.init(
  config: HyperPayConfig.test( // or HyperPayConfig.live for production
    merchantIdentifier: 'YOUR_MERCHANT_ID',
    companyName: 'YOUR_COMPANY_NAME',
    authToken: 'YOUR_AUTH_TOKEN',
    entityId: 'YOUR_ENTITY_ID',
  ),
);
```

### Process a Payment

```dart
try {
  final result = await HyperPay.I.pay(
    amount: 100.0,
    currency: 'SAR',
    method: PaymentMethod.card, // or PaymentMethod.applePay
  );

  switch (result.status) {
    case PaymentStatus.success:
      print('Payment successful! Transaction ID: ${result.transactionId}');
    case PaymentStatus.failed:
      print('Payment failed: ${result.error}');
    case PaymentStatus.canceled:
      print('Payment was canceled');
    case PaymentStatus.pending:
      print('Payment is pending');
  }
} catch (e) {
  print('Error processing payment: $e');
}
```

### Check Apple Pay Availability

```dart
if (await HyperPay.I.hasApplePay) {
  // Show Apple Pay button
}
```

## Test Cards

### Credit Cards (Success)
```
Card Number: 4440 0000 0990 0010
Cardholder Name: Any Name
Expiry Date: 01/39
CVV: 100
Result: Success

Card Number: 5123 4500 0000 0008
Cardholder Name: Any Name
Expiry Date: 01/39
CVV: 100
Result: Success
```

### Credit Cards (Failure)
```
Card Number: 5204 7300 0000 2514
Cardholder Name: Any Name
Expiry Date: 01/39
CVV: 251
Result: Fail
```

### MADA Cards
```
Card Number: 5360 2301 5942 7034
Cardholder Name: Any Name
Expiry Date: 11/24
CVV: 850
```

## Example App

Check out the [example](example) directory for a complete sample app demonstrating all features.

<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="example/screenshots/payment_methods.png" width="250" alt="Payment Methods">
  <img src="example/screenshots/card_payment.png" width="250" alt="Card Payment">
  <img src="example/screenshots/apple_pay.png" width="250" alt="Apple Pay">
</div>

## API Documentation

### HyperPay

The main class for interacting with the payment gateway.

- `HyperPay.I` - Singleton instance
- `HyperPay.init()` - Initialize the SDK
- `HyperPay.isInitialized` - Check if SDK is initialized
- `HyperPay.config` - Current configuration

### Payment Methods

```dart
enum PaymentMethod {
  applePay,
  card,
  mada,
}
```

### Payment Status

```dart
enum PaymentStatus {
  success,
  failed,
  canceled,
  pending,
}
```

### Configuration

```dart
// Test Environment
final config = HyperPayConfig.test(
  merchantIdentifier: 'YOUR_MERCHANT_ID',
  companyName: 'YOUR_COMPANY_NAME',
  authToken: 'YOUR_AUTH_TOKEN',
  entityId: 'YOUR_ENTITY_ID',
);

// Live Environment
final config = HyperPayConfig.live(
  merchantIdentifier: 'YOUR_LIVE_MERCHANT_ID',
  companyName: 'YOUR_COMPANY_NAME',
  authToken: 'YOUR_LIVE_AUTH_TOKEN',
  entityId: 'YOUR_LIVE_ENTITY_ID',
);
```

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) to get started.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
