import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../services/database_service.dart';
import '../../widgets/room_card.dart';
import '../../widgets/user_avatar.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

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
      builder: (context, snapshot) {
        UserModel user = defaultUser;
        if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
          final data = snapshot.data!.snapshot.value;
          if (data is Map) {
            user = UserModel.fromJson(data);
          }
        }

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
                          user: user,
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
                                user.name,
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
                RecentRoomTile(
                  name: 'Late Night Chill',
                  host: 'Sarah',
                  listeners: 4,
                  imageUrl: 'https://picsum.photos/seed/nightchill/100',
                  onTap: () => Navigator.of(context).pushNamed('/now-playing'),
                ),

                const SizedBox(height: AppConstants.spacingSm),

                RecentRoomTile(
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
      },
    );
  }
}

class RecentRoomTile extends StatelessWidget {
  final String name;
  final String host;
  final int listeners;
  final String imageUrl;
  final VoidCallback? onTap;

  const RecentRoomTile({
    super.key,
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
