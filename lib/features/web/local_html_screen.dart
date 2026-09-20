import 'package:azkar/core/widgets/dls/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocalHtmlScreen extends StatefulWidget {
  const LocalHtmlScreen({super.key, required this.title, required this.assetPath});

  final String title;
  final String assetPath;

  @override
  State<LocalHtmlScreen> createState() => _LocalHtmlScreenState();
}

class _LocalHtmlScreenState extends State<LocalHtmlScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadFlutterAsset(widget.assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.title,
      body: WebViewWidget(controller: _controller),
    );
  }
}
