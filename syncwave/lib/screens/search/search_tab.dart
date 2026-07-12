import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/music_model.dart';
import '../../services/music_service.dart';
import '../../services/playback_service.dart';
import '../library/library_tab.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.pagePaddingH,
          vertical: AppConstants.spacingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Search', style: AppTextStyles.headingMedium),
            const SizedBox(height: AppConstants.spacingMd),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _query = value.trim().toLowerCase();
                });
              },
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Search by song name or artist...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.outline,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: const BorderSide(color: AppColors.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: MusicService().getMyMusic(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && _query.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  List<MusicModel> allSongs = [];
                  if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                    final data = snapshot.data!.snapshot.value;
                    if (data is Map) {
                      allSongs = data.entries.map((e) {
                        return MusicModel.fromJson(e.value as Map);
                      }).toList();
                    }
                  }

                  final filteredSongs = allSongs.where((song) {
                    final titleMatch = song.title.toLowerCase().contains(_query);
                    final artistMatch = song.artist.toLowerCase().contains(_query);
                    return titleMatch || artistMatch;
                  }).toList();

                  if (filteredSongs.isEmpty) {
                    return Center(
                      child: Text(
                        _query.isEmpty ? 'Type to find your songs...' : 'No songs or artists found',
                        style: const TextStyle(color: AppColors.outline),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredSongs.length,
                    itemBuilder: (context, index) {
                      final music = filteredSongs[index];
                      return LibraryTrackTile(
                        title: music.title,
                        artist: music.artist,
                        genre: 'Audio',
                        imageUrl: null,
                        onTap: () {
                          PlaybackService().playSong(music, filteredSongs);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
