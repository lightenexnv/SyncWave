import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_constants.dart';

enum RoomCardStyle { primary, surface }

class RoomCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData actionIcon;
  final RoomCardStyle cardStyle;
  final VoidCallback? onTap;

  const RoomCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionIcon,
    this.cardStyle = RoomCardStyle.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = cardStyle == RoomCardStyle.primary;
    final bgColor = isPrimary
        ? AppColors.primary
        : AppColors.surfaceContainerLow;
    final textColor = isPrimary
        ? AppColors.onPrimary
        : AppColors.onSurfaceVariant;
    final iconBgColor = isPrimary
        ? AppColors.onPrimary.withAlpha(30)
        : AppColors.surfaceContainerHigh;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(actionIcon, color: textColor, size: 22),
            ),

            const SizedBox(height: AppConstants.spacingXl),

            // Title
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(color: textColor),
            ),

            const SizedBox(height: 4),

            // Subtitle
            Text(
              subtitle,
              style: AppTextStyles.body.copyWith(
                color: textColor.withAlpha(isPrimary ? 200 : 180),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
