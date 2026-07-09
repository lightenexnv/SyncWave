import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/song_model.dart';
import '../../widgets/song_tile.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXl),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusFull,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.pagePaddingH,
                  ),
                  children: [
                    const SizedBox(height: AppConstants.spacingMd),

                    // Queue Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Up Next', style: AppTextStyles.headingMedium),
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusMd,
                            ),
                          ),
                          child: const Icon(
                            Icons.shuffle_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingLg),

                    // NOW PLAYING section
                    Text('NOW PLAYING', style: AppTextStyles.overline),
                    const SizedBox(height: AppConstants.spacingSm),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusXl,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SongTile(
                        song: DummySongs.nowPlaying,
                        variant: SongTileVariant.nowPlaying,
                        onMore: () {},
                      ),
                    ),

                    const SizedBox(height: AppConstants.spacingLg),

                    // PLAYING NEXT section
                    Text('PLAYING NEXT', style: AppTextStyles.overline),
                    const SizedBox(height: AppConstants.spacingSm),

                    // Queue list
                    ...DummySongs.queue
                        .skip(1)
                        .map(
                          (song) => SongTile(
                            song: song,
                            onTap: () {
                              // TODO: Connect skip-to-song in audio player
                            },
                          ),
                        ),

                    const SizedBox(height: AppConstants.spacingXxl),

                    // Autoplay footer
                    _AutoplayFooter(),

                    const SizedBox(height: AppConstants.spacingXxl),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AutoplayFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.all_inclusive_rounded,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Text(
            'Autoplay is on',
            style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 6),
          Text(
            'Similar music will play automatically\nwhen your queue ends.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.onSurfaceVariant,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
