import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/music_service.dart';

class UploadZone extends StatefulWidget {
  const UploadZone({super.key});

  @override
  State<UploadZone> createState() => _UploadZoneState();
}

class _UploadZoneState extends State<UploadZone> {
  bool uploading = false;
  final MusicService musicService = MusicService();

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
              onPressed: uploading
                  ? null
                  : () async {
                      setState(() {
                        uploading = true;
                      });

                      await musicService.uploadMusic();

                      if (mounted) {
                        setState(() {
                          uploading = false;
                        });
                      }
                    },
              icon: const Icon(
                Icons.add_rounded,
                size: 18,
              ),
              label: Text(uploading ? "Uploading..." : "Add Songs"),
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
