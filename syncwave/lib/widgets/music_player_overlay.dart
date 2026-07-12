import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_constants.dart';
import '../services/playback_service.dart';

class MusicPlayerOverlay extends StatefulWidget {
  const MusicPlayerOverlay({super.key});

  @override
  State<MusicPlayerOverlay> createState() => _MusicPlayerOverlayState();
}

class _MusicPlayerOverlayState extends State<MusicPlayerOverlay> {
  final PlaybackService _playbackService = PlaybackService();
  bool _isLiked = false;

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _playbackService.isVisible,
        _playbackService.isMinimized,
        _playbackService.currentSong,
        _playbackService.isPlaying,
        _playbackService.position,
        _playbackService.duration,
        _playbackService.volume,
      ]),
      builder: (context, child) {
        if (!_playbackService.isVisible.value) return const SizedBox.shrink();

        final song = _playbackService.currentSong.value;
        if (song == null) return const SizedBox.shrink();

        final isMinimized = _playbackService.isMinimized.value;
        final isPlaying = _playbackService.isPlaying.value;
        final pos = _playbackService.position.value;
        final dur = _playbackService.duration.value;
        final vol = _playbackService.volume.value;

        final double progress = dur.inMilliseconds > 0
            ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
            : 0.0;

        final topPadding = MediaQuery.of(context).padding.top;

        if (isMinimized) {
          return Container(
            height: 72.0,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                )
              ],
            ),
            child: _buildMiniPlayer(song, isPlaying, progress),
          );
        } else {
          return Positioned.fill(
            child: Material(
              color: AppColors.background,
              child: _buildFullPlayer(song, isPlaying, progress, pos, dur, vol, topPadding),
            ),
          );
        }
      },
    );
  }

  Widget _buildMiniPlayer(dynamic song, bool isPlaying, double progress) {
    return GestureDetector(
      onTap: () {
        _playbackService.isMinimized.value = false;
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 3,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 56,
                      height: 56,
                      color: AppColors.surfaceContainerLowest,
                      child: const Icon(
                        Icons.music_note_rounded,
                        color: AppColors.primary,
                        size: 32,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                  IconButton(
                    onPressed: () {
                      _playbackService.togglePlay();
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: AppColors.onSurface,
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _playbackService.playNext();
                    },
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      color: AppColors.onSurface,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullPlayer(dynamic song, bool isPlaying, double progress, Duration pos, Duration dur, double vol, double topPadding) {
    final artworkWidth = MediaQuery.of(context).size.width - 48;

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy > 12) {
          _playbackService.isMinimized.value = true;
        }
      },
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.fromLTRB(24, topPadding + 12, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        _playbackService.isMinimized.value = true;
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 32,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'NOW PLAYING',
                      style: AppTextStyles.overline.copyWith(
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
                const Spacer(),
                Center(
                  child: Container(
                    width: artworkWidth,
                    height: artworkWidth * 0.9,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      color: AppColors.primary,
                      size: 80,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            style: AppTextStyles.headingMedium.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            song.artist,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isLiked = !_isLiked;
                        });
                      },
                      icon: Icon(
                        _isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: _isLiked ? AppColors.primary : AppColors.onSurface,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.surfaceContainerHigh,
                        thumbColor: AppColors.primary,
                      ),
                      child: Slider(
                        value: progress,
                        onChanged: (value) {
                          final targetMs = (value * dur.inMilliseconds).round();
                          _playbackService.seek(Duration(milliseconds: targetMs));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(pos), style: AppTextStyles.caption),
                          Text(_formatDuration(dur), style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        _playbackService.skipBackward();
                      },
                      icon: const Icon(
                        Icons.replay_10_rounded,
                        size: 28,
                        color: AppColors.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _playbackService.playPrevious();
                      },
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        size: 36,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          _playbackService.togglePlay();
                        },
                        icon: Icon(
                          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 40,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _playbackService.playNext();
                      },
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        size: 36,
                        color: AppColors.onSurface,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _playbackService.skipForward();
                      },
                      icon: const Icon(
                        Icons.forward_10_rounded,
                        size: 28,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _playbackService.setVolume(vol == 0 ? 1.0 : 0.0);
                      },
                      icon: Icon(
                        vol == 0 ? Icons.volume_mute_rounded : Icons.volume_up_rounded,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                          activeTrackColor: AppColors.onSurfaceVariant,
                          inactiveTrackColor: AppColors.surfaceContainerHigh,
                          thumbColor: AppColors.onSurfaceVariant,
                        ),
                        child: Slider(
                          value: vol,
                          onChanged: (value) {
                            _playbackService.setVolume(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
