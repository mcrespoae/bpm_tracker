import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:metra/core/ads/ad_helper.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final adUnitId = AdHelper.bannerAdUnitId;
    if (adUnitId == null) {
      debugPrint('Ads not supported on this platform.');
      return;
    }

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
            _loadFailed = false;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('$ad failed to load: $error');
          ad.dispose();
          setState(() {
            _loadFailed = true;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // If ad is not supported or failed to load, don't show any placeholder
    if (AdHelper.bannerAdUnitId == null || _loadFailed) {
      return const SizedBox.shrink();
    }

    return const SizedBox(
      height: 50,
      child: Center(
        child: Text(
          'LOADING AD...',
          style: TextStyle(color: Colors.white10, fontSize: 10, letterSpacing: 2),
        ),
      ),
    );
  }
}
