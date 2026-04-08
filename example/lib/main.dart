import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:premium_ads_v2/premium_ads_v2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PremiumAds Adapter V2 Example',
      theme: ThemeData.dark(),
      home: const AdsHome(),
    );
  }
}

class AdsHome extends StatefulWidget {
  const AdsHome({super.key});

  @override
  State<AdsHome> createState() => _AdsHomeState();
}

class _AdsHomeState extends State<AdsHome> {
  // AdMob ad unit IDs (replace with your own)
  static const String _bannerAdUnitId = 'ca-app-pub-2142338037257831/5013815038';
  static const String _interstitialAdUnitId = 'ca-app-pub-2142338037257831/1616542060';
  static const String _rewardedAdUnitId = 'ca-app-pub-2142338037257831/6768646189';
  static const String _rewardedInterstitialAdUnitId = 'ca-app-pub-2142338037257831/9846792399';
  static const String _appOpenAdUnitId = 'ca-app-pub-2142338037257831/3283026116';

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  RewardedInterstitialAd? _rewardedInterstitialAd;
  AppOpenAd? _appOpenAd;

  bool _sdkInitialized = false;
  final List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _initSdk();
  }

  Future<void> _initSdk() async {
    _log('Initializing Google Mobile Ads SDK...');

    // Enable PremiumAds adapter debug logging
    await PremiumAdsV2.setDebug(true);

    final status = await MobileAds.instance.initialize();
    _log('MobileAds initialized.');
    status.adapterStatuses.forEach((name, st) {
      _log('$name | ${st.state}');
    });

    setState(() => _sdkInitialized = true);
    _log('Ready! Tap a button to load ads.');
  }

  void _log(String msg) {
    final ts = TimeOfDay.now().format(context).padLeft(8);
    setState(() => _logs.insert(0, '[$ts] $msg'));
  }

  void _loadBanner() {
    _log('Loading banner...');
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => _log('Banner loaded'),
        onAdFailedToLoad: (_, err) => _log('Banner failed: ${err.message}'),
        onAdImpression: (_) => _log('Banner impression'),
        onAdClicked: (_) => _log('Banner clicked'),
      ),
    )..load();
    setState(() {});
  }

  void _loadInterstitial() {
    _log('Loading interstitial...');
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _log('Interstitial loaded');
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) => _log('Interstitial shown'),
            onAdDismissedFullScreenContent: (ad) {
              _log('Interstitial dismissed');
              ad.dispose();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (err) => _log('Interstitial failed: ${err.message}'),
      ),
    );
  }

  void _loadRewarded() {
    _log('Loading rewarded...');
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _log('Rewarded loaded');
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) => _log('Rewarded shown'),
            onAdDismissedFullScreenContent: (ad) {
              _log('Rewarded dismissed');
              ad.dispose();
            },
          );
          ad.show(onUserEarnedReward: (_, reward) {
            _log('Earned reward: ${reward.amount} ${reward.type}');
          });
        },
        onAdFailedToLoad: (err) => _log('Rewarded failed: ${err.message}'),
      ),
    );
  }

  void _loadRewardedInterstitial() {
    _log('Loading rewarded interstitial...');
    RewardedInterstitialAd.load(
      adUnitId: _rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _log('Rewarded interstitial loaded');
          _rewardedInterstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) => _log('Rewarded interstitial shown'),
            onAdDismissedFullScreenContent: (ad) {
              _log('Rewarded interstitial dismissed');
              ad.dispose();
            },
          );
          ad.show(onUserEarnedReward: (_, reward) {
            _log('Earned reward: ${reward.amount} ${reward.type}');
          });
        },
        onAdFailedToLoad: (err) => _log('Rewarded interstitial failed: ${err.message}'),
      ),
    );
  }

  void _loadAppOpen() {
    _log('Loading app open...');
    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _log('App open loaded');
          _appOpenAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) => _log('App open shown'),
            onAdDismissedFullScreenContent: (ad) {
              _log('App open dismissed');
              ad.dispose();
            },
          );
          ad.show();
        },
        onAdFailedToLoad: (err) => _log('App open failed: ${err.message}'),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
    _appOpenAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PremiumAds Adapter V2 Example')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    _btn('Load Banner', _loadBanner),
                    _btn('Load Interstitial', _loadInterstitial),
                    _btn('Load Rewarded', _loadRewarded),
                    _btn('Load Rewarded Interstitial', _loadRewardedInterstitial),
                    _btn('Load App Open', _loadAppOpen),
                    if (_bannerAd != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      color: Colors.black26,
                      constraints: const BoxConstraints(minHeight: 200),
                      child: Text(
                        _logs.isEmpty ? 'Logs...' : _logs.join('\n'),
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: _sdkInitialized ? onPressed : null,
          child: Text(label),
        ),
      ),
    );
  }
}
