import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../widgets/user_avatar.dart';

class CreateRoomScreen extends StatelessWidget {
  const CreateRoomScreen({super.key});

  // TODO: This room code should come from Firebase Firestore room creation
  static const String _roomCode = '482931';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLow,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            _AppBar(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.pagePaddingH,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppConstants.spacingXl),

                    // Title Section
                    Text('Create Room', style: AppTextStyles.headingMedium),
                    const SizedBox(height: 6),
                    Text(
                      'Share this code with friends',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: AppConstants.spacingXl),

                    // Room Code Display
                    Text(_roomCode, style: AppTextStyles.roomCode),

                    const SizedBox(height: AppConstants.spacingXl),

                    // Action Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Copy Code
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                const ClipboardData(text: _roomCode),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Room code copied!'),
                                  backgroundColor: AppColors.inverseSurface,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.radiusFull,
                                    ),
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy_outlined, size: 18),
                            label: const Text('Copy Code'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 52),
                              foregroundColor: AppColors.onSurface,
                              side: const BorderSide(
                                color: AppColors.outlineVariant,
                              ),
                              shape: const StadiumBorder(),
                              backgroundColor: AppColors.surface,
                            ),
                          ),
                        ),

                        const SizedBox(width: AppConstants.spacingMd),

                        // Share
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Connect native share sheet here
                            },
                            icon: const Icon(Icons.share_rounded, size: 18),
                            label: const Text('Share'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 52),
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.onPrimary,
                              shape: const StadiumBorder(),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingXxl * 2),

                    // Waiting Section
                    _WaitingForFriends(),

                    const SizedBox(height: AppConstants.spacingMd),

                    // Live indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.outline,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Room is live and discoverable',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingXl),

                    // Start Listening
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate after room is actually created in Firebase
                          Navigator.of(context).pushNamed('/now-playing');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: const StadiumBorder(),
                          elevation: 0,
                        ),
                        child: const Text('Start Listening'),
                      ),
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

class _AppBar extends StatelessWidget {
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
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: AppColors.onSurface),
          ),
          Expanded(
            child: Center(
              child: Text(
                'SyncWave',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _WaitingForFriends extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('WAITING FOR FRIENDS TO JOIN...', style: AppTextStyles.overline),
        const SizedBox(height: AppConstants.spacingMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Host avatar (filled)
            UserAvatar(
              user: DummyUsers.host,
              size: AppConstants.avatarLg,
              showHostBadge: true,
            ),

            const SizedBox(width: AppConstants.spacingMd),

            // Waiting slot 1
            _WaitingSlot(hasDots: true),

            const SizedBox(width: AppConstants.spacingMd),

            // Waiting slot 2
            _WaitingSlot(hasDots: false),
          ],
        ),
      ],
    );
  }
}

class _WaitingSlot extends StatelessWidget {
  final bool hasDots;

  const _WaitingSlot({required this.hasDots});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppConstants.avatarLg,
      height: AppConstants.avatarLg,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.outlineVariant,
          width: 1.5,
          style: BorderStyle.solid,
        ),
        color: AppColors.surfaceContainerLow,
      ),
      child: hasDots
          ? Center(
              child: Text(
                '···',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.outline,
                  letterSpacing: 2,
                ),
              ),
            )
          : null,
    );
  }
}
