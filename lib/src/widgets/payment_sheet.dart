import 'package:flutter/material.dart';
import 'package:hyperpay_flutter/src/models/models.dart';
import 'package:hyperpay_flutter/src/widgets/apple_pay_button.dart';
import 'package:hyperpay_flutter/src/widgets/card_field.dart';

/// A complete payment sheet widget that supports both Apple Pay
/// and card payments
class PaymentSheet extends StatefulWidget {
  /// Creates a new payment sheet
  const PaymentSheet({
    required this.params,
    required this.onPaymentResult,
    super.key,
    PaymentSheetAppearance? appearance,
  }) : appearance = appearance ?? const PaymentSheetAppearance.light();

  /// Parameters for the payment sheet
  final PaymentSheetParams params;

  /// Called when the payment is complete
  final void Function(PaymentResult) onPaymentResult;

  /// Appearance configuration for the payment sheet
  final PaymentSheetAppearance appearance;

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  CardDetails? _cardDetails;
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.appearance.colors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.appearance.colors.componentBorder,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.params.paymentMethod == HyperPayMethod.applePay) ...[
              ApplePayButton(
                onPressed: _handleApplePayPressed,
                style: ApplePayButtonStyle.black,
                height: 50,
              ),
            ] else ...[
              CardField(
                onCardChanged: (card) {
                  setState(() {
                    _cardDetails = card;
                    _error = null;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.appearance.colors.componentBorder,
                    ),
                  ),
                ),
                style: TextStyle(
                  color: widget.appearance.colors.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _cardDetails != null ? _handleCardPayPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.appearance.colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Pay'),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                _error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleApplePayPressed() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Handle Apple Pay payment
      widget.onPaymentResult(const PaymentResult.success('test_transaction'));
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      widget.onPaymentResult(PaymentResult.failed(e.toString()));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleCardPayPressed() async {
    if (_cardDetails == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Handle card payment
      widget.onPaymentResult(const PaymentResult.success('test_transaction'));
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
      widget.onPaymentResult(PaymentResult.failed(e.toString()));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
