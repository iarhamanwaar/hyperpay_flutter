import 'package:flutter/material.dart';
import 'package:hyperpay_flutter/hyperpay_flutter.dart';

/// Main entry point for the HyperPay example app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize HyperPay
  await HyperPay.init(
    config: HyperPayConfig.test(
      merchantIdentifier: 'merchant.com.example.app',
      companyName: 'Example Store',
      authToken: 'YOUR_AUTH_TOKEN',
      entityId: 'YOUR_ENTITY_ID',
    ),
  );

  runApp(const ExampleApp());
}

/// The root widget of the example app
class ExampleApp extends StatelessWidget {
  /// Creates a new example app
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HyperPay Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
        ),
        useMaterial3: true,
      ),
      home: const PaymentScreen(),
    );
  }
}

/// Screen that demonstrates payment functionality
class PaymentScreen extends StatefulWidget {
  /// Creates a new payment screen
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;
  final _amountController = TextEditingController(text: '100.00');
  PaymentMethod _selectedMethod = PaymentMethod.card;

  Future<void> _handlePayment() async {
    if (_isLoading) return;

    final amount = _amountController.text.trim();
    if (!_isValidAmount(amount)) {
      await _showErrorDialog('Please enter a valid amount');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await HyperPay.I.pay(
        amount: double.parse(amount),
        currency: 'SAR',
        method: _selectedMethod,
      );

      if (!mounted) return;

      switch (result.status) {
        case PaymentStatus.success:
          await _showSuccessDialog(result.transactionId!);
        case PaymentStatus.failed:
          await _showErrorDialog(result.error!);
        case PaymentStatus.canceled:
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment was canceled')),
            );
          }
        case PaymentStatus.pending:
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Payment is pending')),
            );
          }
      }
    } on FormatException catch (e) {
      if (!mounted) return;
      await _showErrorDialog('Invalid amount format: ${e.message}');
    } catch (e) {
      if (!mounted) return;
      await _showErrorDialog(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isValidAmount(String amount) {
    try {
      final value = double.parse(amount);
      return value > 0;
    } catch (_) {
      return false;
    }
  }

  Future<void> _showSuccessDialog(String transactionId) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.green,
          size: 48,
        ),
        title: const Text('Payment Successful'),
        content: Text('Transaction ID: $transactionId'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _showErrorDialog(String error) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.error_outline,
          color: Colors.red,
          size: 48,
        ),
        title: const Text('Payment Failed'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HyperPay Example'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Amount Input
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(
              labelText: 'Amount (SAR)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 24),

          // Payment Method Selection
          const Text(
            'Select Payment Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _PaymentMethodCard(
            title: 'Credit Card',
            subtitle: 'Pay with Visa, Mastercard, or MADA',
            icon: Icons.credit_card,
            isSelected: _selectedMethod == PaymentMethod.card,
            onTap: () => setState(() => _selectedMethod = PaymentMethod.card),
          ),
          const SizedBox(height: 8),
          FutureBuilder<bool>(
            future: HyperPay.I.hasApplePay,
            builder: (context, snapshot) {
              final isAvailable = snapshot.data ?? false;
              return _PaymentMethodCard(
                title: 'Apple Pay',
                subtitle: isAvailable
                    ? 'Quick and secure payment with Apple Pay'
                    : 'Apple Pay is not available on this device',
                icon: Icons.apple,
                isSelected: _selectedMethod == PaymentMethod.applePay,
                onTap: isAvailable
                    ? () =>
                        setState(() => _selectedMethod = PaymentMethod.applePay)
                    : null,
              );
            },
          ),
          const SizedBox(height: 32),

          // Pay Button
          FilledButton.icon(
            onPressed: _isLoading ? null : _handlePayment,
            icon: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.payment),
            label: Text(
              _isLoading
                  ? 'Processing...'
                  : 'Pay ${_amountController.text} SAR',
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;

    return Card(
      clipBehavior: Clip.antiAlias,
      color: isSelected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 32,
                color: isEnabled
                    ? isSelected
                        ? theme.colorScheme.primary
                        : null
                    : theme.disabledColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isEnabled ? null : theme.disabledColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isEnabled ? null : theme.disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
