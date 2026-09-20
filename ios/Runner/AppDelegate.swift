import UIKit
import AVFAudio
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private static var audioChannelRegistered = false

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)
    configureAudioSession()
    registerAudioChannelIfNeeded()
    return result
  }

  private func registerAudioChannelIfNeeded() {
    guard !Self.audioChannelRegistered,
          let controller = window?.rootViewController as? FlutterViewController else {
      return
    }
    Self.audioChannelRegistered = true
    let channel = FlutterMethodChannel(
      name: "com.anany.azkar/audio",
      binaryMessenger: controller.binaryMessenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "bundleResourcePath":
        guard let args = call.arguments as? [String: Any],
              let name = args["name"] as? String else {
          result(FlutterError(code: "bad_args", message: nil, details: nil))
          return
        }
        result(self?.resolveMp3Path(name: name))
      case "prepareAudioSession":
        self?.configureAudioSession()
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  /// Matches Copy Bundle Resources: files live under `Runner/raw/` in repo but copy flat into `.app`.
  private func resolveMp3Path(name: String) -> String? {
    let bundle = Bundle.main
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }

    var base = (trimmed as NSString).deletingPathExtension
    if base.isEmpty { base = trimmed }

    let candidates = [base, trimmed]

    for candidate in candidates {
      if let path = bundle.path(forResource: candidate, ofType: "mp3") {
        return path
      }
      if let path = bundle.path(forResource: candidate, ofType: "mp3", inDirectory: "raw") {
        return path
      }
      if let path = bundle.path(forResource: "\(candidate).mp3", ofType: nil) {
        return path
      }
      if let path = bundle.path(forResource: "\(candidate).mp3", ofType: nil, inDirectory: "raw") {
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
