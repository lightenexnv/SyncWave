import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

enum ButtonVariant { primary, secondary, ghost }

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final ButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final Widget? leadingWidget;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = ButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.leadingWidget,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (variant) {
      case ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: _buildContent(AppColors.onPrimary),
        );

      case ButtonVariant.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.surfaceContainerHigh,
            foregroundColor: AppColors.onSurface,
            shape: const StadiumBorder(),
            elevation: 0,
          ),
          child: _buildContent(AppColors.onSurface),
        );

      case ButtonVariant.ghost:
        return OutlinedButton(
          onPressed: isLoading ? null : onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: const StadiumBorder(),
            side: const BorderSide(color: AppColors.outlineVariant, width: 1),
          ),
          child: _buildContent(AppColors.primary),
        );
    }
  }

  Widget _buildContent(Color contentColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: contentColor),
      );
    }

    final children = <Widget>[];

    if (leadingWidget != null) {
      children.add(leadingWidget!);
      children.add(const SizedBox(width: 10));
    } else if (leadingIcon != null) {
      children.add(Icon(leadingIcon, size: 20, color: contentColor));
      children.add(const SizedBox(width: 10));
    }

    children.add(
      Text(label, style: AppTextStyles.button.copyWith(color: contentColor)),
    );

    if (trailingIcon != null) {
      children.add(const SizedBox(width: 10));
      children.add(Icon(trailingIcon, size: 20, color: contentColor));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
