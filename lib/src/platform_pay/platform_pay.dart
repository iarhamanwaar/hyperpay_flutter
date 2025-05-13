import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Platform-specific payment implementation
class PlatformPay {
  static const MethodChannel _channel = MethodChannel(
    'com.bugvi.hyperpay_flutter/payment',
  );

  /// Whether the current platform supports platform-specific payments
  /// (Apple Pay on iOS)
  static bool get isPlatformSupported =>
      defaultTargetPlatform == TargetPlatform.iOS;

  /// Check if Apple Pay is available on the device
  static Future<bool> isApplePayAvailable() async {
    if (!isPlatformSupported) return false;

    try {
      final result = await _channel.invokeMethod<bool>('isApplePayAvailable');
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check Apple Pay availability: ${e.message}');
      return false;
    }
  }
}

/// A platform-specific payment button (Apple Pay button on iOS)
class PlatformPayButton extends StatelessWidget {
  /// Creates a platform-specific payment button
  const PlatformPayButton({
    required this.onPressed,
    required this.style,
    required this.type,
    super.key,
    this.borderRadius = 8.0,
    this.onError,
  });

  /// Called when the button is pressed
  final VoidCallback onPressed;

  /// The style of the button
  final String style;

  /// The type of the button
  final String type;

  /// The border radius of the button
  final double borderRadius;

  /// Called when an error occurs
  final void Function(String error)? onError;

  @override
  Widget build(BuildContext context) {
    // Only show on iOS
    if (!PlatformPay.isPlatformSupported) {
      return const SizedBox.shrink();
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS => UiKitView(
          viewType: 'com.bugvi.hyperpay_flutter/apple_pay_button',
          creationParams: {
            'style': style,
            'type': type,
            'borderRadius': borderRadius,
          },
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (int viewId) {
            MethodChannel('com.bugvi.hyperpay_flutter/apple_pay_button_$viewId')
                .setMethodCallHandler((call) async {
              switch (call.method) {
                case 'onPressed':
                  onPressed();
                case 'onError':
                  final error = call.arguments as String;
                  onError?.call(error);
              }
            });
          },
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
