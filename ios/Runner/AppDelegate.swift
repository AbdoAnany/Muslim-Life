import UIKit
import AVFAudio
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private static var audioChannelRegistered = false
  private var audioChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    configureAudioSession()
    registerAudioChannelIfNeeded()
    // window?.rootViewController is often still nil here on scene-based Flutter apps.
    DispatchQueue.main.async { [weak self] in
      self?.registerAudioChannelIfNeeded()
    }
    return result
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
    super.applicationDidBecomeActive(application)
    registerAudioChannelIfNeeded()
  }

  private func flutterViewController() -> FlutterViewController? {
    if let controller = window?.rootViewController as? FlutterViewController {
      return controller
    }
    if let nav = window?.rootViewController as? UINavigationController,
       let controller = nav.viewControllers.first as? FlutterViewController {
      return controller
    }
    if #available(iOS 13.0, *) {
      for scene in UIApplication.shared.connectedScenes {
        guard let windowScene = scene as? UIWindowScene else { continue }
        for window in windowScene.windows {
          if let controller = window.rootViewController as? FlutterViewController {
            return controller
          }
          if let nav = window.rootViewController as? UINavigationController,
             let controller = nav.viewControllers.first as? FlutterViewController {
            return controller
          }
        }
      }
    }
    return nil
  }

  private func registerAudioChannelIfNeeded() {
    guard !Self.audioChannelRegistered,
          let controller = flutterViewController() else {
      if !Self.audioChannelRegistered {
        NSLog("AppDelegate: audio channel deferred — FlutterViewController not ready")
      }
      return
    }
    Self.audioChannelRegistered = true
    let channel = FlutterMethodChannel(
      name: "com.anany.azkar/audio",
      binaryMessenger: controller.binaryMessenger
    )
    audioChannel = channel
    NSLog("AppDelegate: registered com.anany.azkar/audio MethodChannel")
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "bundleResourcePath":
        guard let args = call.arguments as? [String: Any],
              let name = args["name"] as? String else {
          result(FlutterError(code: "bad_args", message: nil, details: nil))
          return
        }
        let resolved = self?.resolveMp3Path(name: name)
        if let resolved {
          NSLog("AppDelegate: bundleResourcePath(\(name)) => \(resolved)")
        } else {
          NSLog("AppDelegate: bundleResourcePath(\(name)) => nil")
        }
        result(resolved)
      case "prepareAudioSession":
        self?.configureAudioSession()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  /// Prefer `raw/` subdirectory (folder copy), then flat bundle root.
  private func resolveMp3Path(name: String) -> String? {
    let bundle = Bundle.main
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }

    var base = (trimmed as NSString).deletingPathExtension
    if base.isEmpty { base = trimmed }

    let candidates = [base, trimmed]

    for candidate in candidates {
      if let path = bundle.path(forResource: candidate, ofType: "mp3", inDirectory: "raw") {
        return path
      }
      if let path = bundle.path(forResource: "\(candidate).mp3", ofType: nil, inDirectory: "raw") {
        return path
      }
      if let path = bundle.path(forResource: candidate, ofType: "mp3") {
        return path
      }
      if let path = bundle.path(forResource: "\(candidate).mp3", ofType: nil) {
        return path
      }
    }
    return nil
  }

  private func configureAudioSession() {
    let session = AVAudioSession.sharedInstance()
    do {
      try session.setCategory(.playback, mode: .default, options: [])
      try session.setActive(true)
    } catch {
      NSLog("AppDelegate: AVAudioSession setup failed: \(error.localizedDescription)")
    }
  }
}
