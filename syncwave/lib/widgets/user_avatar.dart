import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/user_model.dart';

class UserAvatar extends StatelessWidget {
  final UserModel user;
  final double size;
  final bool showName;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 44,
    this.showName = false,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = Stack(
      clipBehavior: Clip.none,
      children: [
        // Avatar circle
        CircleAvatar(
          radius: size / 2,
          backgroundColor: AppColors.surfaceDark2,
          backgroundImage: NetworkImage(user.avatarUrl),
        ),

        // Host badge
        if (user.isHost)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.backgroundDark, width: 1.5),
              ),
              child: const Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: 9,
              ),
            ),
          ),
      ],
    );

    if (!showName) return avatar;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        avatar,
        const SizedBox(height: 6),
        Text(
          user.name.split(' ').first,
          style: AppTextStyles.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
