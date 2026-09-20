import 'dart:io';

import 'package:azkar/core/config/app_contact.dart';
import 'package:azkar/core/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await launchUrl(uri);
    }
  }

  Future<void> _rateApp() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
      return;
    }
    if (Platform.isAndroid) {
      await _launch(AppStoreConfig.playStoreUrl);
    } else {
      await _launch(AppStoreConfig.appStoreUrl);
    }
  }

  Future<void> _shareApp(BuildContext context) async {
    final text = StringBuffer()
      ..writeln('حمّل تطبيق ${AppContact.appName}')
      ..writeln(AppStoreConfig.playStoreUrl);
    if (Platform.isIOS) {
      text.writeln(AppStoreConfig.appStoreUrl);
    }
    await Share.share(text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('عن التطبيق'),
          backgroundColor: kMainColor,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              AppContact.appName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kMainColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppContact.appDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.6),
            ),
            const SizedBox(height: 24),
            _sectionTitle(context, 'اتصل بنا'),
            Card(
              child: Column(
                children: [
                  _actionTile(
                    icon: Icons.mail_outline,
                    title: 'البريد الإلكتروني',
                    subtitle: AppContact.supportEmail.isEmpty
                        ? 'غير مُعد — عدّل lib/core/config/app_contact.dart'
                        : AppContact.supportEmail,
                    enabled: AppContact.supportEmail.isNotEmpty,
                    onTap: () => _launch('mailto:${AppContact.supportEmail}'),
                  ),
                  const Divider(height: 1),
                  _actionTile(
                    icon: Icons.call_outlined,
                    title: 'الهاتف',
                    subtitle: AppContact.phoneE164.isEmpty
                        ? 'غير مُعد'
                        : AppContact.phoneE164,
                    enabled: AppContact.phoneE164.isNotEmpty,
                    onTap: () => _launch('tel:${AppContact.phoneE164}'),
                  ),
                  const Divider(height: 1),
                  _actionTile(
                    icon: Icons.chat_outlined,
                    title: 'واتساب',
                    subtitle: AppContact.whatsAppE164.isEmpty
                        ? 'غير مُعد'
                        : AppContact.whatsAppE164,
                    enabled: AppContact.whatsAppE164.isNotEmpty,
                    onTap: () {
                      final digits = AppContact.whatsAppE164.replaceAll(RegExp(r'[^\d+]'), '');
                      _launch('https://wa.me/${digits.replaceFirst('+', '')}');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(context, 'التطبيق'),
            Card(
              child: Column(
                children: [
                  _actionTile(
                    icon: Icons.share_outlined,
                    title: 'شارك التطبيق',
                    onTap: () => _shareApp(context),
                  ),
                  const Divider(height: 1),
                  _actionTile(
                    icon: Icons.star_outline,
                    title: 'قيّم التطبيق',
                    onTap: _rateApp,
                  ),
                  if (AppContact.websiteUrl.isNotEmpty) ...[
                    const Divider(height: 1),
                    _actionTile(
                      icon: Icons.language,
                      title: 'الموقع',
                      onTap: () => _launch(AppContact.websiteUrl),
                    ),
                  ],
                  if (AppContact.facebookUrl.isNotEmpty) ...[
                    const Divider(height: 1),
                    _actionTile(
                      icon: Icons.facebook,
                      title: 'فيسبوك',
                      onTap: () => _launch(AppContact.facebookUrl),
                    ),
                  ],
                  if (AppContact.twitterUrl.isNotEmpty) ...[
                    const Divider(height: 1),
                    _actionTile(
                      icon: Icons.link,
                      title: 'تويتر / X',
                      onTap: () => _launch(AppContact.twitterUrl),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'معرّف الحزمة: ${AppStoreConfig.androidId}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    bool enabled = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      enabled: enabled,
      leading: Icon(icon, color: enabled ? kMainColor : Colors.grey),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_left),
      onTap: enabled ? onTap : null,
    );
  }
}
