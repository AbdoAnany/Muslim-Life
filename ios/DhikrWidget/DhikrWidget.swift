import SwiftUI
import WidgetKit

/// Must match `HomeWidget.setAppGroupId` in Flutter (`group.com.anany.azkar`).
private let widgetGroupId = "group.com.anany.azkar"
private let dhikrTextKey = "dhikr_text"
private let dhikrCountKey = "dhikr_count"
private let dhikrNextReminderKey = "dhikr_next_reminder"

struct DhikrEntry: TimelineEntry {
  let date: Date
  let dhikrText: String
  let count: Int
  let nextReminder: String
}

struct DhikrProvider: TimelineProvider {
  func placeholder(in context: Context) -> DhikrEntry {
    DhikrEntry(date: Date(), dhikrText: "سبحان الله", count: 0, nextReminder: "")
  }

  private func readEntry() -> DhikrEntry {
    let prefs = UserDefaults(suiteName: widgetGroupId)
    let text = prefs?.string(forKey: dhikrTextKey) ?? "سبحان الله"
    let count = prefs?.integer(forKey: dhikrCountKey) ?? 0
    let next = prefs?.string(forKey: dhikrNextReminderKey) ?? ""
    return DhikrEntry(date: Date(), dhikrText: text, count: count, nextReminder: next)
  }

  func getSnapshot(in context: Context, completion: @escaping (DhikrEntry) -> Void) {
    completion(readEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<DhikrEntry>) -> Void) {
    let entry = readEntry()
    let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date().addingTimeInterval(900)
    completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
  }
}

struct DhikrWidgetEntryView: View {
  var entry: DhikrProvider.Entry

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(red: 0.35, green: 0.76, blue: 0.56), Color(red: 0.0, green: 0.45, blue: 0.40)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      VStack(alignment: .trailing, spacing: 6) {
        Text("حياة المسلم")
          .font(.caption2)
          .foregroundStyle(.white.opacity(0.85))
          .frame(maxWidth: .infinity, alignment: .trailing)
        Text(entry.dhikrText)
          .font(.headline)
          .bold()
          .foregroundStyle(.white)
          .multilineTextAlignment(.trailing)
          .frame(maxWidth: .infinity, alignment: .trailing)
        Text("\(entry.count)")
          .font(.system(size: 34, weight: .bold, design: .rounded))
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity, alignment: .center)
        if !entry.nextReminder.isEmpty {
          Text("التذكير: \(entry.nextReminder)")
            .font(.caption)
            .foregroundStyle(.white.opacity(0.9))
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
      }
      .padding(12)
    }
    .widgetURL(URL(string: "muslimlife://increment"))
  }
}

@main
struct DhikrWidget: Widget {
  let kind: String = "DhikrWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: DhikrProvider()) { entry in
      if #available(iOSApplicationExtension 17.0, *) {
        DhikrWidgetEntryView(entry: entry)
          .containerBackground(for: .widget) { Color.clear }
      } else {
        DhikrWidgetEntryView(entry: entry)
      }
    }
    .configurationDisplayName("ذكر")
    .description("عرض الذكر الحالي وعداد السبحة.")
    .supportedFamilies([.systemSmall, .systemMedium])
  }
}
