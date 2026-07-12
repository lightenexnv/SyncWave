import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncwave/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _rememberMe = false;
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await login();
      if(success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account login failed'),
          ),
        );
      }
    }
  }

  Future<bool> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    return user != null;
  }

  Future<bool> login() async {
    final user = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Glow — Top Right (Primary-fixed tint, 20% opacity)
          Positioned(
            top: screenSize.height * 0.1,
            right: -screenSize.width * 0.35,
            child: _AmbientGlow(
              color: const Color(0xFFE2DFFF).withOpacity(0.25),
              size: screenSize.width * 0.9,
              blurRadius: 100,
            ),
          ),

          // Ambient Glow — Bottom Left (Secondary-fixed tint, 20% opacity)
          Positioned(
            bottom: screenSize.height * 0.1,
            left: -screenSize.width * 0.35,
            child: _AmbientGlow(
              color: const Color(0xFFE2E2EC).withOpacity(0.25),
              size: screenSize.width * 0.9,
              blurRadius: 100,
            ),
          ),

          // Top Header (Fitted text for Brand Identity)
          Positioned(
            top: 0,
            left: 0,
            right: 260,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.pagePaddingH,
                  vertical: 24,
                ),
                child: Image.asset(
                  'assets/logos/syncwave_logo.png',
                  width: 10,
                ),
              ),
            ),
          ),

          // Scrollable Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: AppConstants.pagePaddingH,
                  right: AppConstants.pagePaddingH,
                  top: 80,
                  bottom: 24,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Welcome Header
                        const SizedBox(height: 16),
                        Text(
                          'Welcome back',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                            letterSpacing: -0.8,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Re-enter the rhythm of your world.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Email Field
                        CustomTextField(
                          hint: 'name@example.com',
                          label: 'Email',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline_rounded,
                          focusNode: _emailFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_passwordFocus),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter your email';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Password Field with custom trailing label (Forgot password)
                        CustomTextField(
                          hint: '••••••••',
                          label: 'Password',
                          trailingLabel: GestureDetector(
                            onTap: () {
                              // TODO: Navigate to forgot password screen
                            },
                            child: Text(
                              'Forgot password?',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline_rounded,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _onContinue(),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter your password';
                            if (v.length < 6) return 'Password too short';
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),


                        // Sign In Button
                        CustomButton(
                          label: 'Sign In',
                          onTap: _onContinue,
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        const _OrDivider(),

                        const SizedBox(height: 24),

                        // Google Sign In
                        CustomButton(
                          label: 'Google',
                          variant: ButtonVariant.ghost,
                          leadingWidget: const _GoogleIcon(),
                          onTap: () async {
                            final success = await signInWithGoogle();

                            if(!mounted){
                              return;
                            }
                            if(success){
                              Navigator.of(context).pushReplacementNamed('/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Google sign in failed'),
                                ),
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 32),

                        // Sign up link
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed('/signup'),
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 16,
                                ),
                                children: [
                                  const TextSpan(text: "Don't have an account? "),
                                  TextSpan(
                                    text: 'Sign up',
                                    style: AppTextStyles.body.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Copyright Footer
                        Text(
                          'SYNCWAVE HARMONY © 2024',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant.withOpacity(0.4),
                            letterSpacing: 2.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  final Color color;
  final double size;
  final double blurRadius;

  const _AmbientGlow({
    required this.color,
    required this.size,
    required this.blurRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.outlineVariant.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or continue with',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.outline.withOpacity(0.8),
              fontSize: 12,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.outlineVariant.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width * 0.45;
    final center = Offset(cx, cy);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.15
      ..strokeCap = StrokeCap.square;

    // Red Arc (Top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -2.4, // angle start
      1.6,  // sweep angle
      false,
      paint,
    );

    // Yellow Arc (Left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -4.0,
      1.6,
      false,
      paint,
    );

    // Green Arc (Bottom)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0.8,
      1.6,
      false,
      paint,
    );

    // Blue Arc (Right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -0.8,
      1.6,
      false,
      paint,
    );

    // Draw horizontal bar of Google G
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTRB(
        cx,
        cy - size.width * 0.075,
        cx + radius + size.width * 0.075,
        cy + size.width * 0.075,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
