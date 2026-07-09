import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Waveform bars
          SizedBox(
            width: 72,
            height: 44,
            child: CustomPaint(painter: _WaveformPainter()),
          ),
          const SizedBox(height: 8),
          Text(
            'SyncWave',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bars = [
      (0.08, 0.5),
      (0.24, 0.78),
      (0.40, 1.0),
      (0.56, 0.82),
      (0.72, 0.58),
      (0.88, 0.38),
    ];

    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFFFF8E53),
      const Color(0xFFA855F7),
      const Color(0xFF5856D6),
      const Color(0xFF5856D6),
      const Color(0xFF74B9FF),
    ];

    final barW = size.width * 0.10;

    for (int i = 0; i < bars.length; i++) {
      final x = bars[i].$1 * size.width;
      final h = size.height * bars[i].$2;
      final top = (size.height - h) / 2;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x - barW / 2, top, barW, h),
          Radius.circular(barW),
        ),
        Paint()
          ..color = colors[i]
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
