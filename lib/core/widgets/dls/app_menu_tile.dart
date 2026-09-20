import 'package:azkar/core/theme/app_tokens.dart';
import 'package:flutter/material.dart';

/// Home grid menu cell — teal-bordered card with icon and label.
class AppMenuTile extends StatelessWidget {
  const AppMenuTile({
    super.key,
    required this.label,
    required this.imagePath,
    required this.onTap,
    this.heroTag,
    this.fallbackIcon = Icons.menu_book_outlined,
  });

  final String label;
  final String imagePath;
  final VoidCallback onTap;
  final String? heroTag;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final image = Hero(
      tag: heroTag ?? imagePath,
      child: Image.asset(
        imagePath,
        height: 56,
        width: 56,
        errorBuilder: (_, __, ___) => Icon(
          fallbackIcon,
          size: 56,
          color: AppTokens.brand,
        ),
      ),
    );

    return Material(
      color: AppTokens.mushaf,
      elevation: AppTokens.elevationCard,
      borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTokens.radiusLg),
            border: Border.all(color: AppTokens.brand.withOpacity(0.25)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTokens.spaceSm,
            vertical: AppTokens.spaceMd,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image,
              const SizedBox(height: AppTokens.spaceSm),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 14,
                      color: AppTokens.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
