#import "FLTGoogleMobileAdsPlugin.h"

/**
 * The example NativeAdView.xib can be found at
 * github.com/googleads/googleads-mobile-flutter/blob/main/packages/google_mobile_ads/
 *     example/ios/Runner/NativeAdView.xib
 */
@interface NativeAdFactoryExample : NSObject &lt;FLTNativeAdFactory>
@end

@implementation NativeAdFactoryExample
- (GADNativeAdView *)createNativeAd:(GADNativeAd *)nativeAd
                      customOptions:(NSDictionary *)customOptions {
  // Create and place the ad in the view hierarchy.
  GADNativeAdView *adView =
      [[NSBundle mainBundle] loadNibNamed:@"NativeAdView" owner:nil options:nil].firstObject;

  // Populate the native ad view with the native ad assets.
  // The headline is guaranteed to be present in every native ad.
  ((UILabel *)adView.headlineView).text = nativeAd.headline;

  // These assets are not guaranteed to be present. Check that they are before
  // showing or hiding them.
  ((UILabel *)adView.bodyView).text = nativeAd.body;
  adView.bodyView.hidden = nativeAd.body ? NO : YES;

  [((UIButton *)adView.callToActionView) setTitle:nativeAd.callToAction
                                         forState:UIControlStateNormal];
  adView.callToActionView.hidden = nativeAd.callToAction ? NO : YES;

  ((UIImageView *)adView.iconView).image = nativeAd.icon.image;
  adView.iconView.hidden = nativeAd.icon ? NO : YES;

  ((UILabel *)adView.storeView).text = nativeAd.store;
  adView.storeView.hidden = nativeAd.store ? NO : YES;

  ((UILabel *)adView.priceView).text = nativeAd.price;
  adView.priceView.hidden = nativeAd.price ? NO : YES;

  ((UILabel *)adView.advertiserView).text = nativeAd.advertiser;
  adView.advertiserView.hidden = nativeAd.advertiser ? NO : YES;

  // In order for the SDK to process touch events properly, user interaction
  // should be disabled.
  adView.callToActionView.userInteractionEnabled = NO;

  // Associate the native ad view with the native ad object. This is
  // required to make the ad clickable.
  // Note: this should always be done after populating the ad views.
  adView.nativeAd = nativeAd;

  return adView;
}
@end