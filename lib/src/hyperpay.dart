import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hyperpay_flutter/src/models/hyperpay_config.dart';
import 'package:hyperpay_flutter/src/models/payment_method.dart';
import 'package:hyperpay_flutter/src/models/payment_result.dart';
import 'package:hyperpay_flutter/src/services/hyperpay_service.dart';

/// HyperPay payment plugin
class HyperPay {
  HyperPay._();
  static const MethodChannel _channel = MethodChannel(
    'com.bugvi.hyperpay_flutter/payment',
  );

  static HyperPay? _instance;
  static HyperPayConfig? _config;
  static HyperPayService? _service;

  /// Get the singleton instance of HyperPay
  static HyperPay get I {
    assert(
      _instance != null,
      'HyperPay must be initialized first. '
      'Call HyperPay.init() in your app initialization.',
    );
    return _instance!;
  }

  /// Whether HyperPay has been initialized
  static bool get isInitialized => _config != null;

  /// Current configuration
  static HyperPayConfig? get config => _config;

  /// Initialize HyperPay with configuration
  ///
  /// This must be called before making any payments, typically in your
  /// main() function
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   await HyperPay.init(
  ///     config: HyperPayConfig.test(
  ///       merchantIdentifier: 'merchant.com.your.app',
  ///       companyName: 'Your Company Name',
  ///       authToken: 'YOUR_AUTH_TOKEN',
  ///       entityId: 'YOUR_ENTITY_ID',
  ///     ),
  ///   );
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> init({required HyperPayConfig config}) async {
    if (_instance != null) {
      throw StateError('HyperPay is already initialized');
    }

    _instance = HyperPay._();
    _config = config;
    _service = HyperPayService(config: config);

    try {
      await _channel.invokeMethod('initialize', {
        'merchantIdentifier': config.merchantIdentifier,
        'environment': config.environment.value,
        'companyName': config.companyName,
      });
    } on PlatformException catch (e) {
      _instance = null;
      _config = null;
      _service = null;
      debugPrint('Failed to initialize HyperPay: ${e.message}');
      rethrow;
    }
  }

  /// Initiate a payment with the given parameters
  ///
  /// If no checkoutId is provided, one will be created automatically
  /// ```dart
  /// final result = await HyperPay.I.pay(
  ///   amount: 100.0,
  ///   currency: 'SAR',
  ///   method: PaymentMethod.applePay,
  /// );
  ///
  /// if (result.status == PaymentStatus.success) {
  ///   print('Payment successful: ${result.transactionId}');
  /// }
  /// ```
  Future<PaymentResult> pay({
    required double amount,
    required String currency,
    String? checkoutId,
    PaymentMethod method = PaymentMethod.applePay,
  }) async {
    assert(_service != null, 'HyperPay service is not initialized');

    try {
      final finalCheckoutId = checkoutId ??
          await _service!.createCheckoutId(
            amount: amount,
            currency: currency,
          );

      final result = await _channel.invokeMethod('initiatePayment', {
        'checkoutId': finalCheckoutId,
        'amount': amount,
        'currency': currency,
        'paymentMethod': method.toString().split('.').last,
      });

      if (result is Map) {
        final status = result['status'] as String?;
        final transactionId = result['transactionId'] as String?;
        final error = result['error'] as String?;

        switch (status) {
          case 'success':
            return PaymentResult.success(transactionId!);
          case 'failed':
            return PaymentResult.failed(error ?? 'Unknown error');
          case 'canceled':
            return const PaymentResult.canceled();
          default:
            return PaymentResult.failed('Unknown status: $status');
        }
      }

      return const PaymentResult.failed('Invalid response format');
    } on PlatformException catch (e) {
      return PaymentResult.failed(e.message ?? 'Platform error occurred');
    } on HyperPayException catch (e) {
      return PaymentResult.failed(e.message);
    }
  }

  /// Check if Apple Pay is available on the device
  ///
  /// Returns `true` if the device supports Apple Pay and it's
  /// properly configured
  /// ```dart
  /// if (await HyperPay.I.hasApplePay) {
  ///   // Show Apple Pay button
  /// }
  /// ```
  Future<bool> get hasApplePay async {
    if (!defaultTargetPlatform.isIOS) return false;

    try {
      final result = await _channel.invokeMethod<bool>('isApplePayAvailable');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check Apple Pay availability: ${e.message}');
      return false;
    }
  }
}

/// Extension to check platform
extension on TargetPlatform {
  bool get isIOS => this == TargetPlatform.iOS;
}
