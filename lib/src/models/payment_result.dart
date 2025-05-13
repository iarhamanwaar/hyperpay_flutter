/// Status of a payment transaction
enum PaymentStatus {
  /// Payment was successful
  success,

  /// Payment failed
  failed,

  /// Payment was canceled by the user
  canceled,

  /// Payment is pending
  pending,
}

/// Result of a payment operation
sealed class PaymentResult {
  /// Creates a new payment result
  const PaymentResult._({
    required this.transactionId,
    required this.status,
    this.error,
  });

  /// Creates a successful payment result
  const factory PaymentResult.success(String transactionId) = PaymentSuccess;

  /// Creates a failed payment result
  const factory PaymentResult.failed(String error) = PaymentFailed;

  /// Creates a canceled payment result
  const factory PaymentResult.canceled() = PaymentCanceled;

  /// Transaction ID for successful payments
  final String? transactionId;

  /// Status of the payment
  final PaymentStatus status;

  /// Error message for failed payments
  final String? error;
}

/// Successful payment result
class PaymentSuccess extends PaymentResult {
  /// Creates a successful payment result
  const PaymentSuccess(String transactionId)
      : super._(
          transactionId: transactionId,
          status: PaymentStatus.success,
        );
}

/// Failed payment result
class PaymentFailed extends PaymentResult {
  /// Creates a failed payment result
  const PaymentFailed(String error)
      : super._(
          transactionId: null,
          status: PaymentStatus.failed,
          error: error,
        );
}

/// Canceled payment result
class PaymentCanceled extends PaymentResult {
  /// Creates a canceled payment result
  const PaymentCanceled()
      : super._(
          transactionId: null,
          status: PaymentStatus.canceled,
        );
}
