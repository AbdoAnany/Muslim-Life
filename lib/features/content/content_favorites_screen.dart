import 'package:azkar/app_routes.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/features/content/content_favorites_store.dart';
import 'package:azkar/features/content/tasbeeh_content_repository.dart';
import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:flutter/material.dart';

class ContentFavoritesScreen extends StatefulWidget {
  const ContentFavoritesScreen({super.key});

  @override
  State<ContentFavoritesScreen> createState() => _ContentFavoritesScreenState();
}

class _ContentFavoritesScreenState extends State<ContentFavoritesScreen> {
  final _repo = TasbeehContentRepository();
  final _store = ContentFavoritesStore.instance;
  List<ApiModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _store.addListener(_reload);
    _reload();
  }

  @override
  void dispose() {
    _store.removeListener(_reload);
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() => _loading = true);
    final keys = _store.orderedKeys;
    final loaded = <ApiModel>[];
    for (final key in keys) {
      final parsed = ContentFavoritesStore.parseKey(key);
      if (parsed == null) continue;
      final item = await _repo.findByItemId(parsed.catalog, parsed.itemId);
      if (item != null) loaded.add(item);
    }
    if (!mounted) return;
    setState(() {
      _items = loaded;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المفضلة'),
          backgroundColor: kMainColor,
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _items.isEmpty
                ? const Center(child: Text('لا توجد عناصر في المفضلة'))
                : ListView.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: item.description.isNotEmpty
                            ? Text(item.description)
                            : null,
                        trailing: IconButton(
                          icon: Icon(Icons.bookmark, color: kMainColor),
                          onPressed: () async {
                            await _store.toggle(item.appModel, item.itemId);
                          },
                        ),
                        onTap: () => AppRoutes.openContentDetail(context, item),
                      );
                    },
                  ),
      ),
    );
  }
}
