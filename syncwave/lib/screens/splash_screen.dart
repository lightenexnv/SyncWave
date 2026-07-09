import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();

    // Navigate to onboarding after delay
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
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
      body: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo Icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Center(child: _SyncWaveLogoIcon(size: 44)),
              ),

              const SizedBox(height: 20),

              // App Name
              Text(
                'SyncWave',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SyncWave waveform logo built with CustomPainter
class _SyncWaveLogoIcon extends StatelessWidget {
  final double size;

  const _SyncWaveLogoIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.6),
      painter: _WaveformPainter(),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bars = [
      (0.15, 0.5),
      (0.28, 0.75),
      (0.42, 1.0),
      (0.55, 0.85),
      (0.68, 0.6),
      (0.82, 0.4),
    ];

    final colors = [
      const Color(0xFFFF6B6B),
      const Color(0xFFFF8E53),
      const Color(0xFF9B59B6),
      const Color(0xFF5856D6),
      const Color(0xFF5856D6),
      const Color(0xFF74B9FF),
    ];

    final barWidth = size.width * 0.09;

    for (int i = 0; i < bars.length; i++) {
      final x = bars[i].$1 * size.width;
      final heightFraction = bars[i].$2;
      final barHeight = size.height * heightFraction;
      final top = (size.height - barHeight) / 2;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x - barWidth / 2, top, barWidth, barHeight),
        Radius.circular(barWidth / 2),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
