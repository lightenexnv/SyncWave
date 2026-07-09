import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/constants/app_constants.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.pagePaddingH,
              ),
              child: Column(
                children: [
                  const Spacer(flex: 3),

                  // Logo Block
                  _LogoBlock(),

                  const SizedBox(height: AppConstants.spacingXl),

                  // Brand name overline
                  Text('SYNCWAVE', style: AppTextStyles.overline),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Headline
                  Text(
                    'Music feels\nbetter together.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.headingLarge.copyWith(
                      color: AppColors.onSurface,
                      height: 1.2,
                    ),
                  ),

                  const Spacer(flex: 4),

                  // Continue CTA
                  CustomButton(
                    label: 'Continue',
                    trailingIcon: Icons.arrow_forward_rounded,
                    onTap: () => Navigator.of(context).pushNamed('/login'),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoBlock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos/syncwave_logo.png',
      width: 180,
      filterQuality: FilterQuality.high,
    );
  }
}

