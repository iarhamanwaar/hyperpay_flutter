# HyperPay Flutter Example

This example demonstrates how to use the HyperPay Flutter plugin to integrate payments in your Flutter app.

## Features

- 💳 Credit Card Payments
- 🍎 Apple Pay Integration
- 💰 Dynamic Amount Input
- 🎨 Beautiful Material 3 Design
- ✨ Smooth Animations
- ⚡️ Real-time Payment Status
- 🔒 Secure Payment Processing

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/iarhamanwaar/hyperpay_flutter.git
   cd hyperpay_flutter/example
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Update the configuration in `lib/main.dart`:
   ```dart
   await HyperPay.init(
     config: HyperPayConfig.test(
       merchantIdentifier: 'YOUR_MERCHANT_ID',
       companyName: 'YOUR_COMPANY_NAME',
       authToken: 'YOUR_AUTH_TOKEN',
       entityId: 'YOUR_ENTITY_ID',
     ),
   );
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Configuration

### Test Environment

For testing, use the following test cards:

#### Credit Cards (Success)
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

#### Credit Cards (Failure)
```
Card Number: 5204 7300 0000 2514
Cardholder Name: Any Name
Expiry Date: 01/39
CVV: 251
Result: Fail
```

#### MADA Cards
```
Card Number: 5360 2301 5942 7034
Cardholder Name: Any Name
Expiry Date: 11/24
CVV: 850
```

### Live Environment

For production, update the configuration to use your live credentials:

```dart
await HyperPay.init(
  config: HyperPayConfig.live(
    merchantIdentifier: 'YOUR_LIVE_MERCHANT_ID',
    companyName: 'YOUR_COMPANY_NAME',
    authToken: 'YOUR_LIVE_AUTH_TOKEN',
    entityId: 'YOUR_LIVE_ENTITY_ID',
  ),
);
```

## Features Demonstrated

1. **Payment Methods**
   - Credit/Debit Card Payments
   - MADA Cards Support
   - Apple Pay (iOS only)
   - Dynamic method availability check

2. **Amount Handling**
   - Dynamic amount input
   - Input validation
   - Currency support

3. **Error Handling**
   - Graceful error messages
   - User-friendly error dialogs
   - Network error handling

4. **UI/UX**
   - Material 3 design
   - Loading states
   - Success/Error feedback
   - Smooth animations
   - Responsive layout

## Screenshots

<div style="display: flex; flex-wrap: wrap; gap: 10px;">
  <img src="screenshots/payment_methods.png" width="250" alt="Payment Methods">
  <img src="screenshots/card_payment.png" width="250" alt="Card Payment">
  <img src="screenshots/apple_pay.png" width="250" alt="Apple Pay">
  <img src="screenshots/success.png" width="250" alt="Success">
  <img src="screenshots/error.png" width="250" alt="Error">
</div>

## Contributing

Contributions are welcome! Please read our [contributing guidelines](../CONTRIBUTING.md) to get started.

## License

This example app is part of the HyperPay Flutter plugin, which is licensed under the MIT License. See the [LICENSE](../LICENSE) file for details. 