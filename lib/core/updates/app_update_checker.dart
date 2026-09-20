import 'package:azkar/core/config/app_contact.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';

/// Non-blocking store version check (Tasbeeh `UpdateNewVer` pattern).
class AppUpdateChecker {
  static final _newVersion = NewVersionPlus(
    androidId: AppStoreConfig.androidId,
    iOSId: AppStoreConfig.iOSId,
  );

  static Future<void> checkIfNeeded(BuildContext context) async {
    if (!context.mounted) return;
    try {
      final status = await _newVersion.getVersionStatus();
      if (status == null || !status.canUpdate) return;
      if (!context.mounted) return;
      _newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'تحديث',
        dialogText: 'يوجد تحديث جديد من ${AppContact.appName}',
        updateButtonText: 'حدث الآن',
        dismissButtonText: 'لاحقاً',
      );
    } catch (_) {
      // Offline or store lookup failure — ignore.
    }
  }
}
