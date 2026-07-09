import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../models/user_model.dart';

class UserAvatar extends StatelessWidget {
  final UserModel user;
  final double size;
  final bool showHostBadge;
  final bool showStatusDot;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 48,
    this.showHostBadge = false,
    this.showStatusDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Avatar circle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: user.isHost
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            color: AppColors.surfaceContainerHigh,
          ),
          child: ClipOval(child: _avatarContent()),
        ),

        // Host badge
        if (showHostBadge && user.isHost)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.35,
              height: size * 0.35,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rounded,
                color: AppColors.onPrimary,
                size: size * 0.22,
              ),
            ),
          ),

        // Status dot
        if (showStatusDot)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: _statusColor(),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _avatarContent() {
    if (user.avatarUrl != null) {
      return Image.network(
        user.avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _initials(),
      );
    }
    return _initials();
  }

  Widget _initials() {
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';
    return Center(
      child: Text(
        initial,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.onSurfaceVariant,
          fontSize: size * 0.38,
        ),
      ),
    );
  }

  Color _statusColor() {
    switch (user.status) {
      case 'listening':
        return AppColors.primary;
      case 'paused':
        return AppColors.outline;
      case 'offline':
        return AppColors.surfaceContainerHigh;
      default:
        return AppColors.outline;
    }
  }
}
