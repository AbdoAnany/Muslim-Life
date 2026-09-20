import 'package:azkar/core/shared/colors.dart';
import 'package:azkar/models/tasbeeh/api_model.dart';
import 'package:flutter/material.dart';

class ContentDetailScreen extends StatelessWidget {
  const ContentDetailScreen({super.key, required this.item});

  final ApiModel item;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(item.title), backgroundColor: kMainColor),
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
