import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/song_model.dart';

class SongTile extends StatelessWidget {
  final SongModel song;
  final bool isPlaying;
  final VoidCallback? onTap;
  final int? queueNumber;

  const SongTile({
    super.key,
    required this.song,
    this.isPlaying = false,
    this.onTap,
    this.queueNumber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            // Album Artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                song.albumArtUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 52,
                  height: 52,
                  color: AppColors.surfaceDark2,
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: AppColors.secondaryText,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.title,
                    style: AppTextStyles.body.copyWith(
                      color: isPlaying
                          ? AppColors.accent
                          : AppColors.primaryText,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    song.artist,
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Duration / Playing indicator
            if (isPlaying)
              const Icon(
                Icons.equalizer_rounded,
                color: AppColors.accent,
                size: 20,
              )
            else
              Text(song.duration, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
