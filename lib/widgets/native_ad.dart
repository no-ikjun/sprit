import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sprit/common/ui/color_set.dart';

class NativeAdTemplate extends StatefulWidget {
  const NativeAdTemplate({super.key});

  @override
  _NativeTemplateExampleExampleState createState() =>
      _NativeTemplateExampleExampleState();
}

class _NativeTemplateExampleExampleState extends State<NativeAdTemplate> {
  NativeAd? _nativeAd;
  bool _nativeAdIsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Create the ad objects and load ads.
    _nativeAd = NativeAd(
      adUnitId: kReleaseMode
          ? Platform.isAndroid
              ? dotenv.env['ADMOB_ANDROID_NATIVE_AD_UNIT_ID']!
              : dotenv.env['ADMOB_IOS_NATIVE_AD_UNIT_ID']!
          : Platform.isAndroid
              ? 'ca-app-pub-3940256099942544/2247696110'
              : 'ca-app-pub-3940256099942544/3986624511',
      factoryId: 'adFactoryExample',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          //debugPrint('$NativeAd loaded.');
          setState(() {
            _nativeAdIsLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          //debugPrint('$NativeAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => debugPrint('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => debugPrint('$NativeAd onAdClosed.'),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        cornerRadius: 8.0,
        mainBackgroundColor: Colors.transparent,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: ColorSet.white,
          backgroundColor: ColorSet.primary,
          style: NativeTemplateFontStyle.monospace,
          size: 12.0,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: ColorSet.text,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: ColorSet.darkGrey,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.bold,
          size: 16.0,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: ColorSet.semiDarkGrey,
          backgroundColor: Colors.transparent,
          style: NativeTemplateFontStyle.normal,
          size: 16.0,
        ),
      ),
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (_nativeAd != null && _nativeAdIsLoaded)
        ? ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 320,
              minHeight: 90,
              maxWidth: 400,
              maxHeight: Platform.isAndroid ? 90 : 110,
            ),
            child: Container(
              alignment: Alignment.center,
              child: AdWidget(ad: _nativeAd!),
            ),
          )
        : Container(
            height: 110,
          );
  }
}
