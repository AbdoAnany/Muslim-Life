# iOS WidgetKit — Dhikr widget setup

Muslim-Life uses App Group **`group.com.anany.azkar`** so Flutter (`home_widget`) and the **DhikrWidget** extension share `UserDefaults`.

## Xcode steps (signing)

1. Open `ios/Runner.xcworkspace` (or `Runner.xcodeproj` if you do not use CocoaPods yet).
2. Select the **Runner** target → **Signing & Capabilities** → **+ Capability** → **App Groups** → enable `group.com.anany.azkar` (create it in the Apple Developer portal if missing).
3. Select the **DhikrWidgetExtension** target → repeat App Groups with the **same** group id.
4. Ensure bundle identifiers:
   - Runner: `com.anany.azkar`
   - Extension: `com.anany.azkar.DhikrWidget`
5. Build **Runner** on a device (widgets do not appear in all simulators the same way).

## Flutter bridge keys

| Key | Type | Purpose |
|-----|------|---------|
| `dhikr_text` | String | Current dhikr label |
| `dhikr_count` | int | Counter |
| `dhikr_next_reminder` | String | Optional next scheduled reminder label |

Reload widget kind: **`DhikrWidget`** (`HomeWidget.updateWidget(iOSName: 'DhikrWidget')`).

## Deep link

Tapping the widget uses `muslimlife://increment` (handled by `home_widget` background callback when registered).

## Reference

Android widget + Tasbeeh scheduling patterns are mirrored; Tasbeeh did not expose a WidgetKit target in the accessible repo snapshot.
