import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private var audioPluginRegistered = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
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
    guard !audioPluginRegistered else { return }

    guard let controller = resolveFlutterViewController(),
          let registrar = controller.registrar(forPlugin: "AudioBundlePlugin") else {
      NSLog("AppDelegate: FlutterViewController not ready for AudioBundlePlugin")
      return
    }

    AudioBundlePlugin.register(with: registrar)
    audioPluginRegistered = true
  }

  private func resolveFlutterViewController() -> FlutterViewController? {
    if let controller = window?.rootViewController as? FlutterViewController {
      return controller
    }

    for scene in UIApplication.shared.connectedScenes {
      guard let windowScene = scene as? UIWindowScene else { continue }
      for window in windowScene.windows {
        if let controller = window.rootViewController as? FlutterViewController {
          return controller
        }
      }
    }
    return nil
  }
}
