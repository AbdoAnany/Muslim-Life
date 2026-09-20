import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if let registrar = registrar(forPlugin: "AudioBundlePlugin") {
      AudioBundlePlugin.register(with: registrar)
    } else {
      NSLog("AppDelegate: failed to obtain registrar for AudioBundlePlugin")
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
