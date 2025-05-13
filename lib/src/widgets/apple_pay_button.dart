import 'package:flutter/material.dart';
import 'package:hyperpay_flutter/src/platform_pay/platform_pay.dart';

/// Style options for the Apple Pay button
enum ApplePayButtonStyle {
  /// White button with black text
  white,

  /// White button with black text and outline
  whiteOutline,

  /// Black button with white text
  black,

  /// Automatic style based on the platform's appearance
  automatic,
}

/// Type options for the Apple Pay button
enum ApplePayButtonType {
  /// Standard "Apple Pay" button
  plain,

  /// "Buy with Apple Pay" button
  buy,

  /// "Set up Apple Pay" button
  setUp,

  /// "Book with Apple Pay" button
  book,

  /// "Subscribe with Apple Pay" button
  subscribe,

  /// "Donate with Apple Pay" button
  donate,

  /// "Check out with Apple Pay" button
  checkout,
}

/// A button that initiates Apple Pay payment
class ApplePayButton extends StatelessWidget {
  /// Creates an Apple Pay button
  const ApplePayButton({
    required this.onPressed,
    super.key,
    this.style = ApplePayButtonStyle.automatic,
    this.type = ApplePayButtonType.plain,
    this.width = double.infinity,
    this.height = 48,
    this.borderRadius = 8.0,
    this.onError,
  });

  /// Called when the button is pressed
  final VoidCallback onPressed;

  /// The style of the button
  final ApplePayButtonStyle style;

  /// The type of the button
  final ApplePayButtonType type;

  /// The width of the button
  final double width;

  /// The height of the button
  final double height;

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

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveStyle = style == ApplePayButtonStyle.automatic
        ? isDark
            ? ApplePayButtonStyle.white
            : ApplePayButtonStyle.black
        : style;

    return SizedBox(
      width: width,
      height: height,
      child: PlatformPayButton(
        onPressed: onPressed,
        style: effectiveStyle.name,
        type: type.name,
        borderRadius: borderRadius,
        onError: onError,
      ),
    );
  }
}
