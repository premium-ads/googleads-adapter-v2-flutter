# premium_ads_v2

PremiumAds Google AdMob Adapter V2 — Flutter plugin for mediation through PremiumAds.

Supports Android and iOS via the official [google_mobile_ads](https://pub.dev/packages/google_mobile_ads) plugin.

## Supported Ad Formats

- Banner
- Interstitial
- Rewarded
- Rewarded Interstitial
- Native
- App Open

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  google_mobile_ads: ^5.1.0
  premium_ads_v2: ^1.0.1
```

Or via Git:

```yaml
dependencies:
  premium_ads_v2:
    git:
      url: https://github.com/premium-ads/googleads-adapter-v2-flutter.git
```

Then:

```bash
flutter pub get
```

## Configure AdMob Custom Event

In the [AdMob console](https://apps.admob.com), configure a **Custom Event** for each ad unit:

| Platform | Field | Value |
|----------|-------|-------|
| **Android** | Class Name | `net.premiumads.sdk.adapter.PremiumAdsAdapter` |
| **iOS** | Class Name | `PremiumAdsAdapter` |
| Both | Parameter | Your PremiumAds ad unit ID |

The same class works for all 6 ad formats.

## Usage

The adapter is invoked automatically by Google Mobile Ads SDK — no extra code needed. Use the standard `google_mobile_ads` API:

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:premium_ads_v2/premium_ads_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: enable debug logging
  await PremiumAdsV2.setDebug(true);

  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

// Load a banner
final banner = BannerAd(
  adUnitId: 'ca-app-pub-xxxxx/xxxxx',
  size: AdSize.banner,
  request: const AdRequest(),
  listener: BannerAdListener(),
)..load();
```

## Example

A complete example app with all 6 ad formats is in [`example/`](example/).

## Documentation

- [Integration Guide](https://docs.premiumads.net/v2.0/docs/google-admob)
- [Test Ad Units](https://docs.premiumads.net/v2.0/docs/enabling-test-ads)

## Native Dependencies

This plugin pulls native binaries automatically:
- **Android:** `net.premiumads.sdk:admob-adapter-v2` from PremiumAds JFrog Maven
- **iOS:** `PremiumAdsGoogleAdapter` pod from CocoaPods (requires Google Mobile Ads SDK 13.0+)

## Support

Contact your PremiumAds account manager or email support@premiumads.net
