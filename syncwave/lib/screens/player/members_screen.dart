import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../widgets/user_avatar.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  UserModel get _dynamicHost {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null
        ? UserModel(
            uid: currentUser.uid,
            name: currentUser.displayName ?? currentUser.email?.split('@').first ?? 'Host',
            email: currentUser.email ?? '',
            avatarUrl: currentUser.photoURL,
            isHost: true,
            status: 'listening',
          )
        : DummyUsers.host;
  }

  List<UserModel> get _filteredListeners {
    if (_query.isEmpty) return DummyUsers.listeners;
    return DummyUsers.listeners
        .where((u) => u.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text('Room Members', style: AppTextStyles.titleMedium),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Show room options menu
            },
            icon: const Icon(Icons.more_vert_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.pagePaddingH,
              vertical: AppConstants.spacingMd,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              style: AppTextStyles.body,
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.outline,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.surfaceContainerLow,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusFull),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.pagePaddingH,
              ),
              children: [
                // HOST Section
                Text('HOST', style: AppTextStyles.overline),
                const SizedBox(height: AppConstants.spacingMd),
                _HostTile(user: _dynamicHost),

                const SizedBox(height: AppConstants.spacingXl),

                // LISTENERS Section
                Text(
                  'LISTENERS (${DummyUsers.listeners.length})',
                  style: AppTextStyles.overline,
                ),

                const SizedBox(height: AppConstants.spacingMd),

                // Listener list
                ..._filteredListeners.map((user) => _MemberTile(user: user)),

                const SizedBox(height: AppConstants.spacingXxl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HostTile extends StatelessWidget {
  final UserModel user;

  const _HostTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(
          user: user,
          size: AppConstants.avatarXl,
          showHostBadge: true,
        ),
        const SizedBox(width: AppConstants.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: AppTextStyles.titleLarge),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: user.status == 'listening'
                          ? AppColors.primary
                          : AppColors.outline,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _statusLabel(user.status),
                    style: AppTextStyles.labelLarge.copyWith(
                      color: user.status == 'listening'
                          ? AppColors.primary
                          : AppColors.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Volume control
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.volume_up_rounded,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
        ),
      ],
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'listening':
        return 'Listening';
      case 'paused':
        return 'Paused';
      case 'offline':
        return 'Offline';
      default:
        return status;
    }
  }
}

class _MemberTile extends StatelessWidget {
  final UserModel user;

  const _MemberTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          UserAvatar(
            user: user,
            size: AppConstants.avatarMd,
            showStatusDot: false,
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppTextStyles.labelLarge),
                const SizedBox(height: 2),
                Text(
                  _statusLabel(user.status),
                  style: AppTextStyles.caption.copyWith(
                    color: _statusColor(user.status),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'listening':
        return 'Listening';
      case 'paused':
        return 'Paused';
      case 'offline':
        return 'Offline';
      default:
        return status;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'listening':
        return AppColors.onSurfaceVariant;
      case 'paused':
        return AppColors.outline;
      case 'offline':
        return AppColors.outline;
      default:
        return AppColors.outline;
    }
  }
}
