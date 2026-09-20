import 'package:azkar/app_routes.dart';
import 'package:azkar/core/theme/app_tokens.dart';
import 'package:azkar/core/widgets/dls/app_scaffold.dart';
import 'package:azkar/features/content/content_favorites_store.dart';
import 'package:azkar/features/content/tasbeeh_content_repository.dart';
import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:flutter/material.dart';

class ContentListScreen extends StatefulWidget {
  const ContentListScreen({super.key, required this.catalog, required this.title});

  final AppModel catalog;
  final String title;

  @override
  State<ContentListScreen> createState() => _ContentListScreenState();
}

class _ContentListScreenState extends State<ContentListScreen> {
  final _repo = TasbeehContentRepository();
  final _store = ContentFavoritesStore.instance;
  List<ApiModel> _items = [];
  bool _loading = true;

  bool get _canFavorite =>
      ContentFavoritesStore.favoritableCatalogs.contains(widget.catalog);

  @override
  void initState() {
    super.initState();
    _store.addListener(_onFavoritesChanged);
    _load();
  }

  @override
  void dispose() {
    _store.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    final items = await _repo.load(widget.catalog);
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.title,
      body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final isFav =
                      _canFavorite && _store.isFavorite(widget.catalog, item.itemId);
                  return ListTile(
                    title: Text(item.title),
                    subtitle: item.description.isNotEmpty ? Text(item.description) : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_canFavorite)
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.bookmark : Icons.bookmark_border,
                              color: isFav ? AppTokens.brand : null,
                            ),
                            onPressed: () =>
                                _store.toggle(widget.catalog, item.itemId),
                          ),
                        const Icon(Icons.chevron_left),
                      ],
                    ),
                    onTap: () => AppRoutes.openContentDetail(context, item),
                  );
                },
              ),
    );
  }
}
