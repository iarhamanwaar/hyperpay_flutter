// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:hyperpay_flutter/hyperpay_flutter.dart';

void main() {
  group('HyperPay', () {
    test('can be initialized', () async {
      await HyperPay.init(
        config: HyperPayConfig.test(
          merchantIdentifier: 'test.merchant',
          companyName: 'Test Company',
          authToken: 'test_token',
          entityId: 'test_entity',
        ),
      );
      expect(HyperPay.isInitialized, isTrue);
    });
  });
}
