import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    registerAudioPluginIfNeeded()
    DispatchQueue.main.async { [weak self] in
      self?.registerAudioPluginIfNeeded()
    }
    return result
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    registerAudioPluginIfNeeded()
  }

  private func registerAudioPluginIfNeeded() {
    guard let registrar = registrar(forPlugin: "AudioBundlePlugin") else {
      NSLog("AppDelegate: Flutter registrar not ready for AudioBundlePlugin")
      return
    }
    AudioBundlePlugin.register(with: registrar)
  }
}
