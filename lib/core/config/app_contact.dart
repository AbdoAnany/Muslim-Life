/// Edit these values before release. Empty strings disable the related action.
class AppContact {
  static const String appName = 'حياة المسلم';

  /// Product truth: cleaner home for Tasbeeh switchers — same familiar features.
  static const String appDescription =
      'لمن ينتقل من تطبيق التسبيح: الأذكار الصوتية، القرآن، مواقيت الصلاة، القبلة، حصن المسلم، والسبحة — في تجربة أوضح وموحّدة.';

  static const String websiteDisplayHost = 'www.abdoanany.com';

  /// Optional: set support email when ready (leave empty to hide)
  static const String supportEmail = '';

  /// Optional: E.164 phone for tel: links (leave empty to hide)
  static const String phoneE164 = '';

  /// Optional: E.164 for WhatsApp (leave empty to hide)
  static const String whatsAppE164 = '';

  /// Official site only (About / contact).
  static const String websiteUrl = 'https://www.abdoanany.com/';

  static const String facebookUrl = '';
  static const String twitterUrl = '';
}

class AppStoreConfig {
  static const String androidId = 'com.anany.azkar';
  /// Bundle id for iOS; `new_version_plus` uses this for store lookup.
  static const String iOSId = 'com.anany.azkar';

  static String get playStoreUrl =>
      'https://play.google.com/store/apps/details?id=$androidId';

  /// Replace with numeric App Store id when published (App Store Connect).
  static const String? appStoreNumericId = null;

  static String get appStoreUrl => appStoreNumericId != null
      ? 'https://apps.apple.com/app/id$appStoreNumericId'
      : 'https://apps.apple.com/search?term=${Uri.encodeComponent(AppContact.appName)}';
}
