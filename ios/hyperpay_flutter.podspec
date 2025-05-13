#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint hyperpay_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'hyperpay_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Flutter SDK for HyperPay payment gateway'
  s.description      = <<-DESC
A Flutter plugin for integrating HyperPay payment gateway.
                       DESC
  s.homepage         = 'https://github.com/iarhamanwaar/hyperpay_flutter'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Sahibzada Arham Anwaar Bugvi' => 'arhamanwaar@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.preserve_paths = 'OPPWAMobile.xcframework', 'ipworks3ds_sdk.xcframework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework OPPWAMobile -framework ipworks3ds_sdk ' }
  s.vendored_frameworks = 'OPPWAMobile.xcframework', 'ipworks3ds_sdk.xcframework'
  s.platform = :ios, '14.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end 