/// Formats API timezone strings (e.g. `America/Los_Angeles`) for display.
String formatPrayerLocationLabel(String? timezone) {
  if (timezone == null || timezone.isEmpty) return '';
  final segment = timezone.contains('/')
      ? timezone.split('/').last
      : timezone;
  return segment.replaceAll('_', ' ').trim();
}
