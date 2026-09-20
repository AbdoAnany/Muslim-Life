import 'package:azkar/app_routes.dart';
import 'package:azkar/core/shared/colors.dart';
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
  List<ApiModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.title), backgroundColor: kMainColor),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                itemCount: _items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _items[index];
                  return ListTile(
                    title: Text(item.title),
                    subtitle: item.description.isNotEmpty ? Text(item.description) : null,
                    trailing: const Icon(Icons.chevron_left),
                    onTap: () => AppRoutes.openContentDetail(context, item),
                  );
                },
              ),
      ),
    );
  }
}
