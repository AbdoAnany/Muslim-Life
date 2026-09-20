import AVFAudio
import Flutter

/// Registers `com.anany.azkar/audio` on the Flutter engine (not tied to UI window timing).
public final class AudioBundlePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.anany.azkar/audio",
      binaryMessenger: registrar.messenger()
    )
    let instance = AudioBundlePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    instance.configureAudioSession()
    NSLog("AudioBundlePlugin: registered com.anany.azkar/audio on FlutterEngine")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "bundleResourcePath":
      guard let args = call.arguments as? [String: Any],
            let name = args["name"] as? String else {
        result(FlutterError(code: "bad_args", message: nil, details: nil))
        return
      }
      let resolved = Self.resolveMp3Path(name: name)
      if let resolved {
        NSLog("AudioBundlePlugin: bundleResourcePath(\(name)) => \(resolved)")
      } else {
        NSLog("AudioBundlePlugin: bundleResourcePath(\(name)) => nil")
      }
      result(resolved)
    case "prepareAudioSession":
      configureAudioSession()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Prefer `raw/` subdirectory, then flat bundle root (Copy Bundle Resources layouts).
  static func resolveMp3Path(name: String) -> String? {
    let bundle = Bundle.main
    let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return nil }

    var base = (trimmed as NSString).deletingPathExtension
    if base.isEmpty { base = trimmed }

    for candidate in [base, trimmed] {
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
      NSLog("AudioBundlePlugin: AVAudioSession failed: \(error.localizedDescription)")
    }
  }
}
