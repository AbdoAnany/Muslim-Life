/// Edit these values before release. Empty strings disable the related action.
class AppContact {
  static const String appName = 'حياة المسلم';

  static const String appDescription =
      'تطبيق شامل للأذكار، القرآن، مواقيت الصلاة، القبلة، والمحتوى الإسلامي — offline-first where possible.';

  /// TODO: set your support email (e.g. support@example.com)
  static const String supportEmail = '';

  /// TODO: E.164 phone for tel: links (e.g. +201234567890)
  static const String phoneE164 = '';

  /// TODO: E.164 for WhatsApp (digits only after +)
  static const String whatsAppE164 = '';

  /// Optional social / website URLs
  static const String websiteUrl = '';
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
