import Flutter
import PassKit
import OPPWAMobile

public class HyperPayHandler: NSObject, FlutterPlugin, PKPaymentAuthorizationViewControllerDelegate {
    // MARK: - Properties
    
    private var flutterResult: FlutterResult?
    private var provider: OPPPaymentProvider?
    private var checkoutID: String?
    private weak var presentingViewController: UIViewController?
    private var merchantConfig: MerchantConfig?
    
    // MARK: - Configuration
    
    private struct MerchantConfig {
        let identifier: String
        let environment: String
        let companyName: String
    }
    
    // MARK: - Error Definitions
    
    private enum PaymentError: Error {
        case missingParameters
        case invalidCheckoutID
        case presentationError
        case deviceNotSupported
        case invalidAmount
        case notInitialized
        
        var flutterError: FlutterError {
            switch self {
            case .missingParameters:
                return FlutterError(code: "INVALID_ARGUMENTS",
                                  message: "Missing or invalid required parameters",
                                  details: nil)
            case .invalidCheckoutID:
                return FlutterError(code: "INVALID_CHECKOUT_ID",
                                  message: "Checkout ID is invalid or expired",
                                  details: nil)
            case .presentationError:
                return FlutterError(code: "PRESENTATION_ERROR",
                                  message: "Could not present Apple Pay sheet",
                                  details: nil)
            case .deviceNotSupported:
                return FlutterError(code: "DEVICE_NOT_SUPPORTED",
                                  message: "This device does not support Apple Pay",
                                  details: nil)
            case .invalidAmount:
                return FlutterError(code: "INVALID_AMOUNT",
                                  message: "Invalid payment amount",
                                  details: nil)
            case .notInitialized:
                return FlutterError(code: "NOT_INITIALIZED",
                                  message: "HyperPay is not initialized. Call initialize() first",
                                  details: nil)
            }
        }
    }
    
    // MARK: - Flutter Plugin Registration
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.bugvi.hyperpay_flutter/payment",
                                         binaryMessenger: registrar.messenger())
        let instance = HyperPayHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    // MARK: - Method Channel Handler
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.flutterResult = result
            
            switch call.method {
            case "initialize":
                self.handleInitialize(arguments: call.arguments)
            case "initiatePayment":
                self.handleInitiatePayment(arguments: call.arguments)
            case "isApplePayAvailable":
                result(OPPPaymentProvider.deviceSupportsApplePay())
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    // MARK: - Payment Handling
    
    private func handleInitialize(arguments: Any?) {
        guard let args = arguments as? [String: Any],
              let merchantIdentifier = args["merchantIdentifier"] as? String,
              let environment = args["environment"] as? String,
              let companyName = args["companyName"] as? String else {
            flutterResult?(PaymentError.missingParameters.flutterError)
            return
        }
        
        // Store merchant configuration
        merchantConfig = MerchantConfig(
            identifier: merchantIdentifier,
            environment: environment,
            companyName: companyName
        )
        
        // Initialize payment provider
        provider = OPPPaymentProvider(mode: environment == "test" ? .test : .live)
        
        flutterResult?(nil)
    }
    
    private func handleInitiatePayment(arguments: Any?) {
        guard let config = merchantConfig else {
            flutterResult?(PaymentError.notInitialized.flutterError)
            return
        }
        
        guard let args = arguments as? [String: Any],
              let checkoutId = args["checkoutId"] as? String,
              let amount = args["amount"] as? Double,
              let currency = args["currency"] as? String,
              let paymentMethod = args["paymentMethod"] as? String,
              amount > 0 else {
            flutterResult?(PaymentError.missingParameters.flutterError)
            return
        }
        
        // Store checkout ID for later use
        self.checkoutID = checkoutId
        
        if paymentMethod == "applePay" {
            // Verify device supports Apple Pay
            guard OPPPaymentProvider.deviceSupportsApplePay() else {
                flutterResult?(PaymentError.deviceNotSupported.flutterError)
                return
            }
            
            do {
                try initiateApplePay(
                    checkoutId: checkoutId,
                    amount: amount,
                    currency: currency,
                    config: config
                )
            } catch {
                flutterResult?(FlutterError(code: "PAYMENT_ERROR",
                                          message: error.localizedDescription,
                                          details: nil))
            }
        } else {
            // Handle other payment methods
            flutterResult?(false)
        }
    }
    
    private func initiateApplePay(
        checkoutId: String,
        amount: Double,
        currency: String,
        config: MerchantConfig
    ) throws {
        // Create payment request
        let request = OPPPaymentProvider.paymentRequest(
            withMerchantIdentifier: config.identifier,
            countryCode: "SA" // Default to Saudi Arabia, can be made configurable if needed
        )
        
        // Configure request
        request.currencyCode = currency
        request.supportedNetworks = [.mada, .visa, .masterCard] // Common payment networks
        request.merchantCapabilities = .capability3DS
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(
                label: config.companyName,
                amount: NSDecimalNumber(value: amount)
            )
        ]
        
        // Validate request
        guard OPPPaymentProvider.canSubmitPaymentRequest(request) else {
            throw PaymentError.invalidCheckoutID
        }
        
        // Present payment sheet
        guard let paymentController = PKPaymentAuthorizationViewController(paymentRequest: request) else {
            throw PaymentError.presentationError
        }
        
        paymentController.delegate = self
        
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            throw PaymentError.presentationError
        }
        
        presentingViewController = rootViewController
        rootViewController.present(paymentController, animated: true)
    }
    
    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    
    public func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationStatus) -> Void
    ) {
        guard let checkoutID = self.checkoutID else {
            completion(.failure)
            flutterResult?(PaymentError.invalidCheckoutID.flutterError)
            return
        }
        
        do {
            let params = try OPPApplePayPaymentParams(
                checkoutID: checkoutID,
                tokenData: payment.token.paymentData
            )
            
            provider?.submitTransaction(OPPTransaction(paymentParams: params)) { [weak self] (transaction, error) in
                if let error = error {
                    NSLog("Payment Error: \(error.localizedDescription)")
                    completion(.failure)
                    self?.flutterResult?(FlutterError(
                        code: "PAYMENT_ERROR",
                        message: error.localizedDescription,
                        details: nil
                    ))
                } else {
                    NSLog("Payment Success - Transaction Type: \(transaction.type)")
                    completion(.success)
                    self?.flutterResult?(true)
                }
                
                // Clear stored data
                self?.clearPaymentData()
            }
        } catch {
            NSLog("Payment Error: \(error.localizedDescription)")
            completion(.failure)
            flutterResult?(FlutterError(
                code: "PAYMENT_ERROR",
                message: error.localizedDescription,
                details: nil
            ))
            clearPaymentData()
        }
    }
    
    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true) { [weak self] in
            if self?.flutterResult != nil {
                self?.flutterResult?(false)
            }
            self?.clearPaymentData()
        }
    }
    
    // MARK: - Helper Methods
    
    private func clearPaymentData() {
        checkoutID = nil
        flutterResult = nil
        presentingViewController = nil
    }
} 