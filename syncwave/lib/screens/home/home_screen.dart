import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/room_card.dart';
import 'create_room_screen.dart';
import 'join_room_screen.dart';
import '../player/now_playing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _Header(),
                    const SizedBox(height: 36),

                    // Main Actions
                    _MainActions(
                      onCreateRoom: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CreateRoomScreen(),
                        ),
                      ),
                      onJoinRoom: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const JoinRoomScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Now Playing Banner (dummy)
                    _NowPlayingBanner(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NowPlayingScreen(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),

                    // Recent Rooms
                    Text('Recent Rooms', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Rooms list
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final room = AppConstants.dummyRooms[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RoomCard(
                      roomName: room['name'] as String,
                      hostName: room['host'] as String,
                      memberCount: room['members'] as int,
                      genre: room['genre'] as String,
                      imageUrl:
                          'https://picsum.photos/seed/${room['imageId']}/200/200',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NowPlayingScreen(),
                        ),
                      ),
                    ),
                  );
                }, childCount: AppConstants.dummyRooms.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Header with greeting and profile avatar
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening 🎵',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.secondaryText,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text('Alex Rivera', style: AppTextStyles.headingMedium),
            ],
          ),
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.surfaceDark2,
          backgroundImage: const NetworkImage(
            'https://picsum.photos/seed/profile/80/80',
          ),
        ),
      ],
    );
  }
}

// Create Room / Join Room action buttons
class _MainActions extends StatelessWidget {
  final VoidCallback onCreateRoom;
  final VoidCallback onJoinRoom;

  const _MainActions({required this.onCreateRoom, required this.onJoinRoom});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.add_rounded,
            label: 'Create Room',
            subtitle: 'Host a session',
            onTap: onCreateRoom,
            isPrimary: true,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _ActionCard(
            icon: Icons.login_rounded,
            label: 'Join Room',
            subtitle: 'Enter a code',
            onTap: onJoinRoom,
            isPrimary: false,
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.accent : AppColors.cardOverlay,
          borderRadius: BorderRadius.circular(24),
          border: isPrimary
              ? null
              : Border.all(color: AppColors.outline, width: 0.5),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : AppColors.primaryText,
              size: 28,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.headingSmall.copyWith(
                    fontSize: 15,
                    color: isPrimary ? Colors.white : AppColors.primaryText,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(
                    color: isPrimary
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Persistent now playing mini-banner
class _NowPlayingBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _NowPlayingBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark2,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outline, width: 0.5),
        ),
        child: Row(
          children: [
            // Album art
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://picsum.photos/seed/10/60/60',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),

            // Song info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Blinding Lights',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text('The Weeknd', style: AppTextStyles.caption),
                ],
              ),
            ),

            // Live badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.successColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.successColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'LIVE',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.successColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
