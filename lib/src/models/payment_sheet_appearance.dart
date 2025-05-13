import 'package:flutter/material.dart';

/// Appearance configuration for the payment sheet
@immutable
class PaymentSheetAppearance {
  /// Creates a new payment sheet appearance configuration
  const PaymentSheetAppearance({
    required this.colors,
  });

  /// Creates a light theme for the payment sheet
  const factory PaymentSheetAppearance.light() = _LightPaymentSheetAppearance;

  /// Creates a dark theme for the payment sheet
  const factory PaymentSheetAppearance.dark() = _DarkPaymentSheetAppearance;

  /// Colors configuration for the payment sheet
  final PaymentSheetColors colors;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentSheetAppearance && other.colors == colors;
  }

  @override
  int get hashCode => colors.hashCode;
}

class _LightPaymentSheetAppearance extends PaymentSheetAppearance {
  const _LightPaymentSheetAppearance()
      : super(
          colors: const PaymentSheetColors(
            primary: Colors.blue,
            background: Colors.white,
            componentBackground: Color(0xFFEEEEEE),
            componentBorder: Color(0xFFBDBDBD),
            componentDivider: Color(0xFFE0E0E0),
            primaryText: Colors.black,
            secondaryText: Color(0xFF616161),
            componentText: Color(0xCC000000),
            placeholderText: Colors.grey,
            icon: Colors.black,
          ),
        );
}

class _DarkPaymentSheetAppearance extends PaymentSheetAppearance {
  const _DarkPaymentSheetAppearance()
      : super(
          colors: const PaymentSheetColors(
            primary: Colors.blue,
            background: Color(0xFF212121),
            componentBackground: Color(0xFF424242),
            componentBorder: Color(0xFF616161),
            componentDivider: Color(0xFF616161),
            primaryText: Colors.white,
            secondaryText: Color(0xFFE0E0E0),
            componentText: Color(0xCCFFFFFF),
            placeholderText: Color(0xFF9E9E9E),
            icon: Colors.white,
          ),
        );
}

/// Colors configuration for the payment sheet
class PaymentSheetColors {
  /// Creates a colors configuration for the payment sheet
  const PaymentSheetColors({
    required this.primary,
    required this.background,
    required this.componentBackground,
    required this.componentBorder,
    required this.componentDivider,
    required this.primaryText,
    required this.secondaryText,
    required this.componentText,
    required this.placeholderText,
    required this.icon,
  });

  /// Primary color for buttons and interactive elements
  final Color primary;

  /// Background color of the payment sheet
  final Color background;

  /// Background color of components (text fields, etc.)
  final Color componentBackground;

  /// Border color of components
  final Color componentBorder;

  /// Color of dividers between components
  final Color componentDivider;

  /// Primary text color
  final Color primaryText;

  /// Secondary text color
  final Color secondaryText;

  /// Text color within components
  final Color componentText;

  /// Placeholder text color
  final Color placeholderText;

  /// Icon color
  final Color icon;
}
