import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/user_avatar.dart';
import '../../models/user_model.dart';
import '../player/members_screen.dart';

class CreateRoomScreen extends StatelessWidget {
  const CreateRoomScreen({super.key});

  static final List<UserModel> _members = [
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
  ];

  @override
  Widget build(BuildContext context) {
    const code = AppConstants.dummyRoomCode;
    final formattedCode = '${code.substring(0, 3)} ${code.substring(3)}';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back button + title
              Row(
                children: [
                  _BackButton(),
                  const SizedBox(width: 16),
                  Text('Room Code', style: AppTextStyles.headingSmall),
                ],
              ),

              const SizedBox(height: 48),

              // Room code display
              Center(
                child: Column(
                  children: [
                    Text(
                      'Share this code',
                      style: AppTextStyles.caption.copyWith(letterSpacing: 0.4),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 28,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark2,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.outline,
                          width: 0.5,
                        ),
                      ),
                      child: Text(formattedCode, style: AppTextStyles.roomCode),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Code expires in 24 hours',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Copy & Share buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      label: 'Copy Code',
                      variant: ButtonVariant.secondary,
                      icon: Icons.copy_rounded,
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Room code copied!',
                              style: AppTextStyles.body.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: AppColors.surfaceDark2,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      label: 'Share',
                      icon: Icons.ios_share_rounded,
                      onTap: () {
                        // TODO: Connect share sheet here
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Members Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'In the room  (${_members.length})',
                    style: AppTextStyles.headingSmall.copyWith(fontSize: 17),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const MembersScreen()),
                    ),
                    child: Text(
                      'See all',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Members list
              Row(
                children: _members.map((member) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: UserAvatar(user: member, size: 48, showName: true),
                  );
                }).toList(),
              ),

              const Spacer(),

              // End Room button
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: CustomButton(
                  label: 'End Room',
                  variant: ButtonVariant.ghost,
                  icon: Icons.stop_circle_outlined,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primaryText,
          size: 18,
        ),
      ),
    );
  }
}
