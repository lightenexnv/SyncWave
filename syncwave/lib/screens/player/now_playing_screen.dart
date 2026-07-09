import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/user_model.dart';
import 'queue_screen.dart';
import 'members_screen.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _isPlaying = true;
  double _progress = 0.35;

  // Dummy current song
  static const _song = {
    'title': 'Blinding Lights',
    'artist': 'The Weeknd',
    'album': 'After Hours',
    'imageId': '10',
  };

  static final _listeners = [
    UserModel(
      name: 'Alex Rivera',
      avatarUrl: 'https://picsum.photos/seed/11/80/80',
      isHost: true,
    ),
    UserModel(
      name: 'Jordan Lee',
      avatarUrl: 'https://picsum.photos/seed/22/80/80',
    ),
    UserModel(
      name: 'Sam Chen',
      avatarUrl: 'https://picsum.photos/seed/33/80/80',
    ),
    UserModel(
      name: 'Taylor Park',
      avatarUrl: 'https://picsum.photos/seed/44/80/80',
    ),
  ];

  String _formatTime(double progress) {
    const totalSeconds = 202; // 3:22
    final current = (totalSeconds * progress).round();
    final min = current ~/ 60;
    final sec = current % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Ambient background tint (blurred color wash)
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: size.width * 0.9,
              height: size.width * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                _TopBar(
                  onQueueTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const QueueScreen(),
                    );
                  },
                ),

                const Spacer(flex: 1),

                // Album Artwork
                _AlbumArtwork(imageId: _song['imageId']!),

                const SizedBox(height: 36),

                // Song Info
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _song['title']!,
                              style: AppTextStyles.headingMedium.copyWith(
                                fontSize: 26,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _song['artist']!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Toggle favorite / like via backend
                        },
                        icon: const Icon(
                          Icons.favorite_border_rounded,
                          color: AppColors.secondaryText,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Progress Slider
                _ProgressSection(
                  progress: _progress,
                  currentTime: _formatTime(_progress),
                  totalTime: '3:22',
                  onChanged: (v) => setState(() => _progress = v),
                ),

                const SizedBox(height: 28),

                // Player Controls
                _PlayerControls(
                  isPlaying: _isPlaying,
                  onPlayPause: () => setState(() => _isPlaying = !_isPlaying),
                  onPrevious: () {
                    // TODO: Connect previous track
                  },
                  onNext: () {
                    // TODO: Connect next track
                  },
                ),

                const SizedBox(height: 36),

                // Friends Listening Section
                _FriendsSection(
                  listeners: _listeners,
                  onMembersTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MembersScreen()),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Top bar with back and queue button
class _TopBar extends StatelessWidget {
  final VoidCallback onQueueTap;

  const _TopBar({required this.onQueueTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryText,
              size: 30,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Now Playing',
                  style: AppTextStyles.caption.copyWith(letterSpacing: 0.5),
                ),
                Text(
                  'Chill Vibes 🌙',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onQueueTap,
            icon: const Icon(
              Icons.queue_music_rounded,
              color: AppColors.primaryText,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}

// Large album artwork with shadow
class _AlbumArtwork extends StatelessWidget {
  final String imageId;

  const _AlbumArtwork({required this.imageId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final artSize = size.width * 0.72;

    return Center(
      child: Container(
        width: artSize,
        height: artSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.25),
              blurRadius: 50,
              spreadRadius: 8,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.network(
            'https://picsum.photos/seed/$imageId/400/400',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surfaceDark2,
              child: const Icon(
                Icons.music_note_rounded,
                color: AppColors.secondaryText,
                size: 60,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Progress bar with timestamps
class _ProgressSection extends StatelessWidget {
  final double progress;
  final String currentTime;
  final String totalTime;
  final ValueChanged<double> onChanged;

  const _ProgressSection({
    required this.progress,
    required this.currentTime,
    required this.totalTime,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            ),
            child: Slider(value: progress, onChanged: onChanged),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentTime, style: AppTextStyles.caption),
                Text(totalTime, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Prev / Play-Pause / Next controls
class _PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _PlayerControls({
    required this.isPlaying,
    required this.onPlayPause,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Shuffle
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.shuffle_rounded,
              color: AppColors.secondaryText,
              size: 22,
            ),
          ),

          // Previous
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(
              Icons.skip_previous_rounded,
              color: AppColors.primaryText,
              size: 38,
            ),
          ),

          // Play / Pause
          _PlayButton(isPlaying: isPlaying, onTap: onPlayPause),

          // Next
          IconButton(
            onPressed: onNext,
            icon: const Icon(
              Icons.skip_next_rounded,
              color: AppColors.primaryText,
              size: 38,
            ),
          ),

          // Repeat
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.repeat_rounded,
              color: AppColors.secondaryText,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const _PlayButton({required this.isPlaying, required this.onTap});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 150),
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.93,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              widget.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              key: ValueKey(widget.isPlaying),
              color: AppColors.backgroundDark,
              size: 34,
            ),
          ),
        ),
      ),
    );
  }
}

// Friends / listeners row
class _FriendsSection extends StatelessWidget {
  final List<UserModel> listeners;
  final VoidCallback onMembersTap;

  const _FriendsSection({required this.listeners, required this.onMembersTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          // Stacked avatars
          SizedBox(
            width: 80,
            height: 36,
            child: Stack(
              children: List.generate(
                listeners.length.clamp(0, 3),
                (i) => Positioned(
                  left: i * 22.0,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.backgroundDark,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(listeners[i].avatarUrl),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${listeners.length} friends listening',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('in Chill Vibes 🌙', style: AppTextStyles.caption),
              ],
            ),
          ),

          GestureDetector(
            onTap: onMembersTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark2,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'View all',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
