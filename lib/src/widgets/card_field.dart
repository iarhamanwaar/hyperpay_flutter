import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperpay_flutter/src/models/models.dart';

/// A form field for collecting card details
class CardField extends StatefulWidget {
  /// Creates a new card field
  const CardField({
    super.key,
    this.onCardChanged,
    this.decoration,
    this.style,
    this.numberHintText,
    this.expiryHintText,
    this.cvcHintText,
    this.enablePostalCode = false,
    this.autofocus = false,
    this.onFocus,
  });

  /// Called when the card details change
  final void Function(CardDetails?)? onCardChanged;

  /// Decoration for the card field
  final InputDecoration? decoration;

  /// Text style for the card field
  final TextStyle? style;

  /// Hint text for the card number field
  final String? numberHintText;

  /// Hint text for the expiry date field
  final String? expiryHintText;

  /// Hint text for the CVC field
  final String? cvcHintText;

  /// Whether to show the postal code field
  final bool enablePostalCode;

  /// Whether to autofocus the card number field
  final bool autofocus;

  /// Called when the focus changes
  final void Function({required bool hasFocus})? onFocus;

  @override
  State<CardField> createState() => _CardFieldState();
}

class _CardFieldState extends State<CardField> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _cardNumberFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvcFocus = FocusNode();
  CardBrand _brand = CardBrand.unknown;

  @override
  void initState() {
    super.initState();
    _setupFocusListeners();
    _setupTextListeners();
  }

  void _setupFocusListeners() {
    void handleFocusChange() {
      final hasFocus = _cardNumberFocus.hasFocus ||
          _expiryFocus.hasFocus ||
          _cvcFocus.hasFocus;
      widget.onFocus?.call(hasFocus: hasFocus);
    }

    _cardNumberFocus.addListener(handleFocusChange);
    _expiryFocus.addListener(handleFocusChange);
    _cvcFocus.addListener(handleFocusChange);
  }

  void _setupTextListeners() {
    void handleTextChange() {
      final number = _cardNumberController.text;
      final expiry = _expiryController.text;
      final cvc = _cvcController.text;

      if (number.isEmpty && expiry.isEmpty && cvc.isEmpty) {
        widget.onCardChanged?.call(null);
        return;
      }

      final parts = expiry.split('/');
      final month = parts.isNotEmpty ? int.tryParse(parts[0]) : null;
      final year = parts.length > 1 ? int.tryParse('20${parts[1]}') : null;

      widget.onCardChanged?.call(
        CardDetails(
          number: number.replaceAll(' ', ''),
          expiryMonth: month ?? 0,
          expiryYear: year ?? 0,
          cvc: cvc,
          holderName: '',
          brand: _brand,
        ),
      );
    }

    _cardNumberController.addListener(handleTextChange);
    _expiryController.addListener(handleTextChange);
    _cvcController.addListener(handleTextChange);
  }

  void _updateCardBrand(String number) {
    if (number.startsWith('4')) {
      _brand = CardBrand.visa;
    } else if (number.startsWith('5')) {
      _brand = CardBrand.mastercard;
    } else if (number.startsWith('9')) {
      _brand = CardBrand.mada;
    } else {
      _brand = CardBrand.unknown;
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
    );

    return Column(
      children: [
        TextFormField(
          controller: _cardNumberController,
          focusNode: _cardNumberFocus,
          decoration: (widget.decoration ?? defaultDecoration).copyWith(
            hintText: widget.numberHintText ?? 'Card number',
          ),
          style: widget.style,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          autofocus: widget.autofocus,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CardNumberFormatter(),
          ],
          onChanged: (value) {
            _updateCardBrand(value);
            if (value.length >= 19) {
              _expiryFocus.requestFocus();
            }
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _expiryController,
                focusNode: _expiryFocus,
                decoration: (widget.decoration ?? defaultDecoration).copyWith(
                  hintText: widget.expiryHintText ?? 'MM/YY',
                ),
                style: widget.style,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ExpiryDateFormatter(),
                ],
                onChanged: (value) {
                  if (value.length >= 5) {
                    _cvcFocus.requestFocus();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _cvcController,
                focusNode: _cvcFocus,
                decoration: (widget.decoration ?? defaultDecoration).copyWith(
                  hintText: widget.cvcHintText ?? 'CVC',
                ),
                style: widget.style,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _cardNumberFocus.dispose();
    _expiryFocus.dispose();
    _cvcFocus.dispose();
    super.dispose();
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll(' ', '');
    if (text.length > 16) {
      return oldValue;
    }

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.length,
      ),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll('/', '');
    if (text.length > 4) {
      return oldValue;
    }

    if (text.length >= 2) {
      final month = int.tryParse(text.substring(0, 2)) ?? 0;
      if (month > 12 || month == 0) {
        return oldValue;
      }
    }

    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(
        offset: buffer.length,
      ),
    );
  }
}
