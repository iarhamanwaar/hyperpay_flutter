/// The environment for HyperPay SDK
enum Environment {
  /// Test environment for development and testing
  test(value: 'test', baseUrl: 'eu-test.oppwa.com'),

  /// Live environment for production payments
  live(value: 'live', baseUrl: 'eu-prod.oppwa.com');

  /// Creates a new environment
  const Environment({
    required this.value,
    required this.baseUrl,
  });

  /// The string value of the environment
  final String value;

  /// The base URL for API calls
  final String baseUrl;
}
