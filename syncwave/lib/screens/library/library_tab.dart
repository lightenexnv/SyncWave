import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../models/music_model.dart';
import '../../services/music_service.dart';
import '../../services/database_service.dart';
import '../../services/playback_service.dart';
import '../../widgets/user_avatar.dart';
import 'widgets/upload_zone.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final defaultUser = currentUser != null
        ? UserModel(
            uid: currentUser.uid,
            name: currentUser.displayName ?? currentUser.email?.split('@').first ?? 'User',
            email: currentUser.email ?? '',
            avatarUrl: currentUser.photoURL,
          )
        : DummyUsers.currentUser;

    return StreamBuilder<DatabaseEvent>(
      stream: currentUser != null
          ? DatabaseService().getUserProfileStream(currentUser.uid)
          : null,
      builder: (context, profileSnapshot) {
        UserModel user = defaultUser;
        if (profileSnapshot.hasData && profileSnapshot.data!.snapshot.value != null) {
          final data = profileSnapshot.data!.snapshot.value;
          if (data is Map) {
            user = UserModel.fromJson(data);
          }
        }

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.pagePaddingH,
              vertical: AppConstants.spacingMd,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload Library',
                            style: AppTextStyles.headingMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Manage and add tracks to your host collection.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    UserAvatar(user: user, size: 38),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Upload Zone
                const UploadZone(),

                const SizedBox(height: AppConstants.spacingXl),

                // Dynamic StreamBuilder for uploaded tracks
                StreamBuilder<DatabaseEvent>(
                  stream: MusicService().getMyMusic(),
                  builder: (context, snapshot) {
                    int count = 0;
                    List<MusicModel> musicList = [];
                    bool hasData = false;

                    if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                      final data = snapshot.data!.snapshot.value;
                      if (data is Map) {
                        final sortedEntries = data.entries.toList();
                        sortedEntries.sort((a, b) {
                          final aVal = a.value as Map?;
                          final bVal = b.value as Map?;
                          final aTime = aVal?['uploadedAt'] ?? 0;
                          final bTime = bVal?['uploadedAt'] ?? 0;
                          return bTime.compareTo(aTime);
                        });

                        musicList = sortedEntries.map((e) {
                          return MusicModel.fromJson(e.value as Map);
                        }).toList();
                        count = musicList.length;
                        hasData = true;
                      }
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('RECENT TRACKS', style: AppTextStyles.overline),
                            Text(
                              '$count Items',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppConstants.spacingMd),
                        if (snapshot.connectionState == ConnectionState.waiting)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (snapshot.hasError)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              'Error loading songs: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        else if (!hasData || musicList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No songs uploaded yet.',
                                style: TextStyle(color: AppColors.outline),
                              ),
                            ),
                          )
                        else
                          ...musicList.map((music) {
                            return LibraryTrackTile(
                              title: music.title,
                              artist: music.artist,
                              genre: 'Audio',
                              imageUrl: null,
                              onTap: () {
                                PlaybackService().playSong(music, musicList);
                              },
                            );
                          }),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // View All
                Center(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Navigate to full library screen
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(120, 44),
                      side: const BorderSide(color: AppColors.outlineVariant),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'View All',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXxl),
              ],
            ),
          ),
        );
      },
    );
  }
}

class LibraryTrackTile extends StatelessWidget {
  final String title;
  final String artist;
  final String genre;
  final String? imageUrl;
  final VoidCallback? onTap;

  const LibraryTrackTile({
    super.key,
    required this.title,
    required this.artist,
    required this.genre,
    this.imageUrl,
    this.onTap,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 2),
                  Text('$artist • $genre', style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
      ),
      child: const Icon(
        Icons.music_note_rounded,
        color: AppColors.outline,
        size: 22,
      ),
    );
  }
}
