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
    if let registrar = registrar(forPlugin: "AudioBundlePlugin") {
      AudioBundlePlugin.register(with: registrar)
      return
    }

    if let controller = window?.rootViewController as? FlutterViewController {
      AudioBundlePlugin.register(
        with: controller.registrar(forPlugin: "AudioBundlePlugin")!
      )
      return
    }

    for scene in UIApplication.shared.connectedScenes {
      guard let windowScene = scene as? UIWindowScene else { continue }
      for window in windowScene.windows {
        guard let controller = window.rootViewController as? FlutterViewController else {
          continue
        }
        AudioBundlePlugin.register(
          with: controller.registrar(forPlugin: "AudioBundlePlugin")!
        )
        return
      }
    }

    NSLog("AppDelegate: Flutter registrar not ready for AudioBundlePlugin")
  }
}
