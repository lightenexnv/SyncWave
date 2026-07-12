import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/song_model.dart';
import '../../models/user_model.dart';
import '../../widgets/user_avatar.dart';
import 'queue_screen.dart';
import 'members_screen.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _isPlaying = true;
  bool _isLiked = false;
  double _progress = 0.41; // 1:42 of 4:03

  final SongModel _song = DummySongs.nowPlaying;

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Duration get _elapsed =>
      Duration(seconds: (_song.duration.inSeconds * _progress).round());

  Duration get _remaining => _song.duration - _elapsed;

  void _openQueue() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const QueueScreen(),
    );
  }

  void _openMembers() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const MembersScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _PlayerHeader(onClose: () => Navigator.of(context).pop()),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.pagePaddingH,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppConstants.spacingMd),

                    // Album Artwork Section
                    _AlbumArtwork(
                      imageUrl: _song.albumArtUrl,
                      listenerCount: 4,
                    ),

                    const SizedBox(height: AppConstants.spacingLg),

                    // Song Info Section
                    _SongInfo(
                      song: _song,
                      isLiked: _isLiked,
                      onLike: () => setState(() => _isLiked = !_isLiked),
                    ),

                    const SizedBox(height: AppConstants.spacingLg),

                    // Progress Section
                    _ProgressSection(
                      progress: _progress,
                      elapsed: _formatDuration(_elapsed),
                      remaining: '-${_formatDuration(_remaining)}',
                      onChanged: (v) => setState(() => _progress = v),
                    ),

                    const SizedBox(height: AppConstants.spacingLg),

                    // Player Controls
                    _PlayerControls(
                      isPlaying: _isPlaying,
                      onPlayPause: () =>
                          setState(() => _isPlaying = !_isPlaying),
                      onPrevious: () {},
                      onNext: () {},
                      onShuffle: () {},
                      onRepeat: () {},
                    ),

                    const SizedBox(height: AppConstants.spacingXl),

                    // Sync Footer Section
                    _SyncFooter(
                      onQueueTap: _openQueue,
                      onMembersTap: _openMembers,
                    ),

                    const SizedBox(height: AppConstants.spacingXl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _PlayerHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 28,
              color: AppColors.onSurface,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('LISTENING ROOM', style: AppTextStyles.overline),
                Text(
                  'Late Night Drive',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Show room options menu
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlbumArtwork extends StatelessWidget {
  final String imageUrl;
  final int listenerCount;

  const _AlbumArtwork({required this.imageUrl, required this.listenerCount});

  @override
  Widget build(BuildContext context) {
    final size =
        MediaQuery.of(context).size.width - AppConstants.pagePaddingH * 2;

    return Stack(
      children: [
        // Album Art
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusXl),
          child: Image.network(
            imageUrl,
            width: size,
            height: size * 0.82,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: size,
              height: size * 0.82,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(AppConstants.radiusXl),
              ),
              child: const Icon(
                Icons.music_note_rounded,
                color: AppColors.outline,
                size: 64,
              ),
            ),
          ),
        ),

        // Listeners badge
        Positioned(
          top: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface.withAlpha(230),
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.graphic_eq_rounded,
                  size: 16,
                  color: AppColors.onSurface,
                ),
                const SizedBox(width: 6),
                Text(
                  '$listenerCount Listening',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SongInfo extends StatelessWidget {
  final SongModel song;
  final bool isLiked;
  final VoidCallback onLike;

  const _SongInfo({
    required this.song,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mini prev track label (design shows "Lost Highway" chip)
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Lost Highway',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                song.title,
                style: AppTextStyles.headingMedium.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                song.artist,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),

        // Like button
        IconButton(
          onPressed: onLike,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              key: ValueKey(isLiked),
              color: isLiked ? AppColors.primary : AppColors.onSurface,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double progress;
  final String elapsed;
  final String remaining;
  final ValueChanged<double> onChanged;

  const _ProgressSection({
    required this.progress,
    required this.elapsed,
    required this.remaining,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Time labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(elapsed, style: AppTextStyles.caption),
            Text(remaining, style: AppTextStyles.caption),
          ],
        ),

        const SizedBox(height: 4),

        // Progress slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: AppColors.onSurface,
            inactiveTrackColor: AppColors.surfaceContainerHigh,
            thumbColor: AppColors.onSurface,
          ),
          child: Slider(value: progress, onChanged: onChanged),
        ),
      ],
    );
  }
}

class _PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;

  const _PlayerControls({
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
    required this.onShuffle,
    required this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Shuffle
        _ControlIconButton(
          icon: Icons.shuffle_rounded,
          onTap: onShuffle,
          size: 22,
        ),

        // Previous
        _ControlIconButton(
          icon: Icons.skip_previous_rounded,
          onTap: onPrevious,
          size: 28,
        ),

        // Play / Pause
        GestureDetector(
          onTap: onPlayPause,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 52,
              color: AppColors.onSurface,
            ),
          ),
        ),

        // Next
        _ControlIconButton(
          icon: Icons.skip_next_rounded,
          onTap: onNext,
          size: 28,
        ),

        // Repeat
        _ControlIconButton(
          icon: Icons.repeat_rounded,
          onTap: onRepeat,
          size: 22,
        ),
      ],
    );
  }
}

class _ControlIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _ControlIconButton({
    required this.icon,
    required this.onTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: size, color: AppColors.onSurface),
      ),
    );
  }
}

class _SyncFooter extends StatelessWidget {
  final VoidCallback onQueueTap;
  final VoidCallback onMembersTap;

  const _SyncFooter({required this.onQueueTap, required this.onMembersTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMembersTap,
      child: Row(
        children: [
          // Stacked Avatars
          _StackedAvatars(),

          const SizedBox(width: AppConstants.spacingMd),

          // In Sync info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.sync_rounded,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'In Sync',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Neil, Alex + 2 others', style: AppTextStyles.caption),
              ],
            ),
          ),

          // Queue button
          GestureDetector(
            onTap: onQueueTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                const Icon(
                  Icons.queue_music_rounded,
                  size: 20,
                  color: AppColors.onSurface,
                ),
                const SizedBox(width: 6),
                Text(
                  'Queue',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StackedAvatars extends StatelessWidget {
  const _StackedAvatars();

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

    final List<UserModel> members = [
      defaultUser,
      const UserModel(
        id: 'u_alex',
        name: 'Alex',
        avatarUrl: 'https://picsum.photos/seed/alex/100',
      ),
    ];

    const avatarSize = 32.0;
    const overlap = 10.0;
    final totalWidth =
        avatarSize +
        (members.length - 1) * (avatarSize - overlap) +
        avatarSize * 0.6;

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        children: [
          // +2 badge
          Positioned(
            left: members.length * (avatarSize - overlap),
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: Center(
                child: Text(
                  '+2',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
          // User avatars in reverse order so first is on top
          for (int i = members.length - 1; i >= 0; i--)
            Positioned(
              left: i * (avatarSize - overlap),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: UserAvatar(user: members[i], size: avatarSize),
              ),
            ),
        ],
      ),
    );
  }
}
