import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/features/content/content_favorites_store.dart';
import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:flutter/material.dart';

class ContentDetailScreen extends StatefulWidget {
  const ContentDetailScreen({super.key, required this.item});

  final ApiModel item;

  @override
  State<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends State<ContentDetailScreen> {
  final _store = ContentFavoritesStore.instance;

  bool get _canFavorite =>
      ContentFavoritesStore.favoritableCatalogs.contains(widget.item.appModel);

  @override
  void initState() {
    super.initState();
    _store.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isFav = _canFavorite &&
        _store.isFavorite(item.appModel, item.itemId);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(item.title),
          backgroundColor: kMainColor,
          actions: [
            if (_canFavorite)
              IconButton(
                tooltip: isFav ? 'إزالة من المفضلة' : 'إضافة إلى المفضلة',
                icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () => _store.toggle(item.appModel, item.itemId),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.html,
                style: const TextStyle(fontSize: 20, height: 1.8),
                textAlign: TextAlign.right,
              ),
              if (item.description.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  item.description,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
