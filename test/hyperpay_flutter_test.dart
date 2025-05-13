import 'package:flutter_test/flutter_test.dart';
import 'package:hyperpay_flutter/hyperpay_flutter.dart';

void main() {
  group('HyperPayConfig', () {
    test('test environment configuration', () {
      final config = HyperPayConfig.test(
        merchantIdentifier: 'test_merchant',
        companyName: 'Test Company',
        authToken: 'test_token',
        entityId: 'test_entity',
      );

      expect(config.merchantIdentifier, equals('test_merchant'));
      expect(config.environment, equals(Environment.test));
      expect(config.companyName, equals('Test Company'));
      expect(config.authToken, equals('test_token'));
      expect(config.entityId, equals('test_entity'));
    });

    test('production environment configuration', () {
      final config = HyperPayConfig.production(
        merchantIdentifier: 'live_merchant',
        companyName: 'Live Company',
        authToken: 'live_token',
        entityId: 'live_entity',
      );

      expect(config.merchantIdentifier, equals('live_merchant'));
      expect(config.environment, equals(Environment.live));
      expect(config.companyName, equals('Live Company'));
      expect(config.authToken, equals('live_token'));
      expect(config.entityId, equals('live_entity'));
    });
  });

  group('Environment', () {
    test('test environment values', () {
      expect(Environment.test.value, equals('test'));
      expect(Environment.test.baseUrl, equals('eu-test.oppwa.com'));
    });

    test('live environment values', () {
      expect(Environment.live.value, equals('live'));
      expect(Environment.live.baseUrl, equals('eu-prod.oppwa.com'));
    });
  });

  group('PaymentMethod', () {
    test('payment method values', () {
      expect(PaymentMethod.values.length, equals(3));
      expect(
        PaymentMethod.values,
        containsAll([
          PaymentMethod.applePay,
          PaymentMethod.card,
          PaymentMethod.mada,
        ]),
      );
    });
  });

  group('CardDetails', () {
    test('creates valid card details', () {
      const card = CardDetails(
        number: '4111111111111111',
        expiryMonth: 12,
        expiryYear: 2025,
        cvc: '123',
        holderName: 'John Doe',
      );

      expect(card.number, equals('4111111111111111'));
      expect(card.expiryMonth, equals(12));
      expect(card.expiryYear, equals(2025));
      expect(card.cvc, equals('123'));
      expect(card.holderName, equals('John Doe'));
      expect(card.brand, equals(CardBrand.unknown));
    });

    test('copyWith creates new instance with updated values', () {
      const original = CardDetails(
        number: '4111111111111111',
        expiryMonth: 12,
        expiryYear: 2025,
        cvc: '123',
        holderName: 'John Doe',
      );

      final copy = original.copyWith(
        holderName: 'Jane Doe',
        brand: CardBrand.visa,
      );

      expect(copy.number, equals(original.number));
      expect(copy.expiryMonth, equals(original.expiryMonth));
      expect(copy.expiryYear, equals(original.expiryYear));
      expect(copy.cvc, equals(original.cvc));
      expect(copy.holderName, equals('Jane Doe'));
      expect(copy.brand, equals(CardBrand.visa));
    });
  });
}
