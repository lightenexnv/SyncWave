import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/song_model.dart';
import '../../widgets/song_tile.dart';

class QueueScreen extends StatelessWidget {
  const QueueScreen({super.key});

  static List<SongModel> get _songs => AppConstants.dummySongs.map((s) {
    return SongModel(
      title: s['title']!,
      artist: s['artist']!,
      albumArtUrl: 'https://picsum.photos/seed/${s['imageId']}/80/80',
      duration: s['duration']!,
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    final songs = _songs;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outline,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Up Next', style: AppTextStyles.headingSmall),
                Text('${songs.length} songs', style: AppTextStyles.caption),
              ],
            ),
          ),

          const SizedBox(height: 8),

          const Divider(
            color: AppColors.outline,
            height: 1,
            indent: 24,
            endIndent: 24,
          ),

          // Song List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return SongTile(
                  song: songs[index],
                  isPlaying: index == 0,
                  onTap: () {
                    // TODO: Connect play specific track in queue
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
