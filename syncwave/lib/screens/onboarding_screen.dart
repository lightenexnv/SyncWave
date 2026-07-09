import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets/custom_button.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            children: [
              // Illustration area
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Ambient glow
                    Positioned(
                      top: size.height * 0.06,
                      child: Container(
                        width: size.width * 0.75,
                        height: size.width * 0.75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.accent.withValues(alpha: 0.18),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Central illustration
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Stacked avatar group
                        _ListeningIllustration(),
                        const SizedBox(height: 40),

                        // Headline
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Music feels better\ntogether.',
                            style: AppTextStyles.headingLarge.copyWith(
                              height: 1.15,
                              fontSize: 34,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Subtext
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Create a room, invite friends, and listen to the same music in perfect sync — no matter where you are.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Bottom actions
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: Column(
                  children: [
                    CustomButton(
                      label: 'Get Started',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      label: 'Sign In',
                      variant: ButtonVariant.ghost,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Onboarding illustration widget
class _ListeningIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avatarUrls = [
      'https://picsum.photos/seed/a1/80/80',
      'https://picsum.photos/seed/a2/80/80',
      'https://picsum.photos/seed/a3/80/80',
      'https://picsum.photos/seed/a4/80/80',
    ];

    return SizedBox(
      width: 200,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Central disc / vinyl visual
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [
                  AppColors.accent,
                  AppColors.accentDim,
                  AppColors.accentSurface,
                  AppColors.accent,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.4),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: const Icon(
              Icons.waves_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),

          // Surrounding avatars
          ...List.generate(avatarUrls.length, (i) {
            const positions = [
              Offset(-88, -20),
              Offset(-60, 30),
              Offset(60, 30),
              Offset(88, -20),
            ];
            return Positioned(
              left: 100 + positions[i].dx - 20,
              top: 60 + positions[i].dy - 20,
              child: CircleAvatar(
                radius: 22,
                backgroundColor: AppColors.surfaceDark2,
                backgroundImage: NetworkImage(avatarUrls[i]),
              ),
            );
          }),

          // Sound waves (decorative rings)
          ...[80.0, 112.0].map(
            (r) => Container(
              width: r,
              height: r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
