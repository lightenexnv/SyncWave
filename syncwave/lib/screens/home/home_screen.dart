import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../widgets/room_card.dart';
import '../../widgets/user_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [_HomeTab(), _SearchTab(), _LibraryTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_currentIndex],
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

// Home Tab
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.pagePaddingH,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: AppConstants.spacingMd),

                // Header Section
                Row(
                  children: [
                    UserAvatar(
                      user: DummyUsers.currentUser,
                      size: 48,
                      showStatusDot: true,
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _greeting(),
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            DummyUsers.currentUser.name,
                            style: AppTextStyles.titleLarge,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // TODO: Navigate to settings
                      },
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: AppColors.onSurfaceVariant,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.spacingLg),

                // Create Room Card
                RoomCard(
                  title: 'Create Room',
                  subtitle: 'Start listening with friends',
                  actionIcon: Icons.add_circle_outline_rounded,
                  cardStyle: RoomCardStyle.primary,
                  onTap: () => Navigator.of(context).pushNamed('/create-room'),
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Join Room Card
                RoomCard(
                  title: 'Join Room',
                  subtitle: 'Enter invite code',
                  actionIcon: Icons.login_rounded,
                  cardStyle: RoomCardStyle.surface,
                  onTap: () => Navigator.of(context).pushNamed('/join-room'),
                ),

                const SizedBox(height: AppConstants.spacingXl),

                // Recently Joined Section
                Text('Recently joined', style: AppTextStyles.titleMedium),

                const SizedBox(height: AppConstants.spacingMd),

                // Recent Room Tiles
                _RecentRoomTile(
                  name: 'Late Night Chill',
                  host: 'Sarah',
                  listeners: 4,
                  imageUrl: 'https://picsum.photos/seed/nightchill/100',
                  onTap: () => Navigator.of(context).pushNamed('/now-playing'),
                ),

                const SizedBox(height: AppConstants.spacingSm),

                _RecentRoomTile(
                  name: 'Morning Focus',
                  host: 'Alex',
                  listeners: 12,
                  imageUrl: 'https://picsum.photos/seed/morningfocus/100',
                  onTap: () => Navigator.of(context).pushNamed('/now-playing'),
                ),

                const SizedBox(height: AppConstants.spacingXxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentRoomTile extends StatelessWidget {
  final String name;
  final String host;
  final int listeners;
  final String imageUrl;
  final VoidCallback? onTap;

  const _RecentRoomTile({
    required this.name,
    required this.host,
    required this.listeners,
    required this.imageUrl,
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
              child: Image.network(
                imageUrl,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: const Icon(
                    Icons.music_note_rounded,
                    color: AppColors.outline,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 2),
                  Text(
                    'Hosted by $host • $listeners listeners',
                    style: AppTextStyles.caption,
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

// Search Tab placeholder
class _SearchTab extends StatelessWidget {
  const _SearchTab();

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
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                border: Border.all(color: AppColors.outlineVariant),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.search_rounded,
                    color: AppColors.outline,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Find rooms, songs, artists...',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.outline,
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

// Library Tab — Upload screen
class _LibraryTab extends StatelessWidget {
  const _LibraryTab();

  @override
  Widget build(BuildContext context) {
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
                UserAvatar(user: DummyUsers.currentUser, size: 38),
              ],
            ),

            const SizedBox(height: AppConstants.spacingXl),

            // Upload Drop Zone
            _UploadZone(),

            const SizedBox(height: AppConstants.spacingXl),

            // Recent Tracks Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('RECENT TRACKS', style: AppTextStyles.overline),
                Text(
                  '42 Items',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppConstants.spacingMd),

            _LibraryTrackTile(
              title: 'Neon Genesis',
              artist: 'Kavinsky',
              genre: 'Electronic',
              imageUrl: 'https://picsum.photos/seed/neon/80',
            ),
            _LibraryTrackTile(
              title: 'Pacific Coast Highway',
              artist: 'Nightcraft',
              genre: 'Ambient',
              imageUrl: 'https://picsum.photos/seed/pacific/80',
            ),
            _LibraryTrackTile(
              title: 'Subtle Shift',
              artist: 'Unknown Artist',
              genre: 'Beat',
              imageUrl: null,
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
  }
}

class _UploadZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusXl),
        border: Border.all(
          color: AppColors.outlineVariant,
          style: BorderStyle.solid,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
          ),
          const SizedBox(height: 16),
          Text('Select or drop tracks', style: AppTextStyles.titleMedium),
          const SizedBox(height: 6),
          Text('MP3, WAV, or FLAC up to 50MB', style: AppTextStyles.caption),
          const SizedBox(height: 20),
          SizedBox(
            width: 160,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Connect file picker here
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Songs'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: const StadiumBorder(),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LibraryTrackTile extends StatelessWidget {
  final String title;
  final String artist;
  final String genre;
  final String? imageUrl;

  const _LibraryTrackTile({
    required this.title,
    required this.artist,
    required this.genre,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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

// Bottom navigation bar
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: AppConstants.bottomNavHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.search_rounded,
                label: 'Search',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.library_music_rounded,
                label: 'Library',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.radiusFull),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isActive
                  ? AppColors.onPrimary
                  : AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
