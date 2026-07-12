import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import 'home_tab.dart';
import '../search/search_tab.dart';
import '../library/library_tab.dart';
import '../../widgets/music_player_overlay.dart';
import '../../services/playback_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeTab(),
    SearchTab(),
    LibraryTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final navHeight = AppConstants.bottomNavHeight + bottomPadding;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Page Content
          AnimatedBuilder(
            animation: Listenable.merge([
              PlaybackService().isVisible,
              PlaybackService().isMinimized,
            ]),
            builder: (context, child) {
              final isVisible = PlaybackService().isVisible.value;
              final isMinimized = PlaybackService().isMinimized.value;
              double extraPadding = 0.0;
              if (isVisible && isMinimized) {
                extraPadding = 72.0; // Miniplayer height
              }
              return Padding(
                padding: EdgeInsets.only(bottom: navHeight + extraPadding),
                child: _pages[_currentIndex],
              );
            },
          ),

          // 2. Full Player Overlay (when expanded)
          AnimatedBuilder(
            animation: Listenable.merge([
              PlaybackService().isVisible,
              PlaybackService().isMinimized,
            ]),
            builder: (context, child) {
              final isVisible = PlaybackService().isVisible.value;
              final isMinimized = PlaybackService().isMinimized.value;
              if (isVisible && !isMinimized) {
                return const MusicPlayerOverlay();
              }
              return const SizedBox.shrink();
            },
          ),

          // 3. Bottom Panel (Miniplayer + Nav Bar)
          AnimatedBuilder(
            animation: Listenable.merge([
              PlaybackService().isVisible,
              PlaybackService().isMinimized,
            ]),
            builder: (context, child) {
              final isVisible = PlaybackService().isVisible.value;
              final isMinimized = PlaybackService().isMinimized.value;

              if (isVisible && !isMinimized) {
                return const SizedBox.shrink();
              }

              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isVisible && isMinimized)
                      const MusicPlayerOverlay(),
                    _BottomNav(
                      currentIndex: _currentIndex,
                      onTap: (i) => setState(() => _currentIndex = i),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
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
