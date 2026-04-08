// PremiumAds Google AdMob Adapter V2 — Flutter plugin
//
// This is a thin Dart bridge to the native PremiumAds adapter.
// You don't need to call anything from this class for ads to work —
// the adapter is invoked automatically by Google Mobile Ads SDK
// when the publisher configures custom events in the AdMob console.
//
// This wrapper only exposes optional helpers like setDebug().

import 'package:flutter/services.dart';

class PremiumAdsV2 {
  static const MethodChannel _channel = MethodChannel('premium_ads_v2');

  /// Enables verbose debug logging from the PremiumAds adapter.
  ///
  /// Logs are tagged with `[PremiumAdsAdapter]` in:
  /// - **Android Logcat:** filter with `tag:PremiumAdsAdapter`
  /// - **iOS Xcode console:** prefix `[PremiumAdsAdapter]`
  static Future<void> setDebug(bool enabled) async {
    try {
      await _channel.invokeMethod('setDebug', {'enabled': enabled});
    } catch (e) {
      // Silent fail — adapter not loaded yet or platform not supported
    }
  }
}
