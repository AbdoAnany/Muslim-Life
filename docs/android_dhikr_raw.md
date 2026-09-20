# Android dhikr raw audio (`res/raw`)

After sync from `ios/Runner/raw` (Sep 2025):

- **198** mp3 files on both iOS and Android (`~49 MB` each platform folder).
- Source of truth for filenames: `ZekerModel.soundFileNamePath()` → `android.resource://com.anany.azkar/raw/a{zeker_id}` (with `_N` suffix when repeat variants apply).

## Missing files

With the full iOS set copied to Android, **no dhikr mp3s that exist on iOS remain missing on Android**.

If the SQLite/seed catalog references audio not bundled in either platform, playback shows a SnackBar: «ملف الصوت غير متوفر على هذا الجهاز».

## Notification sounds

Scheduled dhikr uses `RawResourceAndroidNotificationSound(fullFileName)` where `fullFileName` matches the raw resource base name (no extension).
