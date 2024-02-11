import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // FlutterViewController를 얻어옵니다.
    if let controller = window?.rootViewController as? FlutterViewController {
      // 메서드 채널을 생성합니다.
      let nativeAdChannel = FlutterMethodChannel(name: "com.yourcompany/nativeAd",
                                                binaryMessenger: controller.binaryMessenger)
      // 메서드 채널을 통해 Flutter로부터 오는 호출을 처리합니다.
      nativeAdChannel.setMethodCallHandler({
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        // 호출된 메서드 이름을 확인합니다.
        if call.method == "removeBorder" {
          // border 제거 로직을 구현합니다.
          self.removeAdBorder()
          result(nil)
        } else {
          result(FlutterMethodNotImplemented)
        }
      })
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func removeAdBorder() {
    // 광고 뷰의 border를 제거하는 로직을 구현합니다.
    // 예시: adView.layer.borderWidth = 0
    // 실제 광고 뷰에 대한 참조를 얻어와야 합니다.
  }
}
