import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_constants.dart';
import '../models/song_model.dart';

enum SongTileVariant { normal, nowPlaying }

class SongTile extends StatelessWidget {
  final SongModel song;
  final SongTileVariant variant;
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const SongTile({
    super.key,
    required this.song,
    this.variant = SongTileVariant.normal,
    this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final isNowPlaying = variant == SongTileVariant.nowPlaying;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            // Album Art
            _AlbumArt(url: song.albumArtUrl, isActive: isNowPlaying),

            const SizedBox(width: 14),

            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: isNowPlaying
                        ? AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          )
                        : AppTextStyles.labelLarge.copyWith(
                            color: AppColors.onSurface,
                          ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    song.artist,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // More button
            if (onMore != null)
              IconButton(
                onPressed: onMore,
                icon: const Icon(
                  Icons.more_horiz,
                  color: AppColors.onSurfaceVariant,
                  size: 20,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: AppConstants.iconButtonSize,
                  minHeight: AppConstants.iconButtonSize,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _AlbumArt extends StatelessWidget {
  final String url;
  final bool isActive;

  const _AlbumArt({required this.url, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          child: Image.network(
            url,
            width: AppConstants.songTileImageSize,
            height: AppConstants.songTileImageSize,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: AppConstants.songTileImageSize,
              height: AppConstants.songTileImageSize,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: AppColors.outline,
                size: 22,
              ),
            ),
          ),
        ),
        if (isActive)
          Container(
            width: AppConstants.songTileImageSize,
            height: AppConstants.songTileImageSize,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(40),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
      ],
    );
  }
}
