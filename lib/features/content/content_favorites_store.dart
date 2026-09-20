import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Favorites for Tasbeeh DB catalog items (separate from Quran [BookmarkCubit]).
class ContentFavoritesStore extends ChangeNotifier {
  ContentFavoritesStore._();
  static final ContentFavoritesStore instance = ContentFavoritesStore._();

  static const _prefsKey = 'content_favorite_ids_v1';

  static const favoritableCatalogs = {
    AppModel.hades,
    AppModel.doaaInQuran,
    AppModel.firstInIslam,
    AppModel.azkarElyome,
    AppModel.islamEvents,
  };

  SharedPreferences? _prefs;
  final Set<String> _ids = {};

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _ids
      ..clear()
      ..addAll(_prefs!.getStringList(_prefsKey) ?? const []);
  }

  static String storageKey(AppModel catalog, String itemId) =>
      '${catalog.name}:$itemId';

  static ({AppModel catalog, String itemId})? parseKey(String key) {
    final i = key.indexOf(':');
    if (i <= 0) return null;
    final catalogName = key.substring(0, i);
    final itemId = key.substring(i + 1);
    for (final c in favoritableCatalogs) {
      if (c.name == catalogName) {
        return (catalog: c, itemId: itemId);
      }
    }
    return null;
  }

  bool isFavorite(AppModel catalog, String itemId) =>
      _ids.contains(storageKey(catalog, itemId));

  Future<void> toggle(AppModel catalog, String itemId) async {
    await init();
    final key = storageKey(catalog, itemId);
    if (_ids.contains(key)) {
      _ids.remove(key);
    } else {
      _ids.add(key);
    }
    await _prefs!.setStringList(_prefsKey, _ids.toList()..sort());
    notifyListeners();
  }

  List<String> get orderedKeys => _ids.toList()..sort();
}
