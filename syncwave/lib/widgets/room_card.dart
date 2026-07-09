import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class RoomCard extends StatelessWidget {
  final String roomName;
  final String hostName;
  final int memberCount;
  final String genre;
  final String imageUrl;
  final VoidCallback? onTap;

  const RoomCard({
    super.key,
    required this.roomName,
    required this.hostName,
    required this.memberCount,
    required this.genre,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardOverlay,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline, width: 0.5),
        ),
        child: Row(
          children: [
            // Album art thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
              child: Image.network(
                imageUrl,
                width: 84,
                height: 84,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 84,
                  height: 84,
                  color: AppColors.surfaceDark2,
                  child: const Icon(
                    Icons.headphones_rounded,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
            ),

            // Room info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      roomName,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text('by $hostName', style: AppTextStyles.caption),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Genre chip
                        _Chip(label: genre),
                        const SizedBox(width: 8),
                        // Member count
                        const Icon(
                          Icons.people_rounded,
                          color: AppColors.secondaryText,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$memberCount listening',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Chevron
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(
                Icons.chevron_right_rounded,
                color: AppColors.secondaryText,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: AppColors.accent),
      ),
    );
  }
}
