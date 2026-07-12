import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:syncwave/services/auth_service.dart';
import 'package:syncwave/services/database_service.dart';
import 'package:syncwave/models/user_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final AuthService _authService = AuthService();
  final DatabaseService _dbService = DatabaseService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<bool> signInWithGoogle() async {
    final user = await _authService.signInWithGoogle();

    if (user != null) {
      await _dbService.saveUserProfile(UserModel(
        uid: user.uid,
        name: user.displayName ?? "",
        email: user.email ?? "",
        avatarUrl: user.photoURL,
        isHost: false,
        status: 'listening',
      ));
      return true;
    }

    return false;
  }

  Future<bool> signin() async {
    final user = await _authService.signup(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (user != null) {
      await _dbService.saveUserProfile(UserModel(
        uid: user.uid,
        name: _nameController.text.trim(),
        email: user.email ?? _emailController.text.trim(),
        avatarUrl: null,
        isHost: false,
        status: 'listening',
      ));
      return true;
    }

    return false;
  }

  void _onCreateAccount() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await signin();

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account creation failed'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Ambient Glow — Top Right (Primary tint, 5% opacity)
          Positioned(
            top: -screenSize.height * 0.1,
            right: -screenSize.width * 0.2,
            child: _AmbientGlow(
              color: AppColors.primary.withOpacity(0.06),
              size: screenSize.width * 0.9,
              blurRadius: 120,
            ),
          ),

          // Ambient Glow — Bottom Left (Secondary Container, 20% opacity)
          Positioned(
            bottom: -screenSize.height * 0.1,
            left: -screenSize.width * 0.2,
            child: _AmbientGlow(
              color: AppColors.secondaryContainer.withOpacity(0.25),
              size: screenSize.width * 0.8,
              blurRadius: 80,
            ),
          ),

          // Brand Header (Faded text: opacity 20%)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.pagePaddingH,
                  vertical: 24,
                ),
                child: Text(
                  'SyncWave',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary.withOpacity(0.2),
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),
          ),

          // Back Button (Top Left - Floating overlay for safe navigation)
          Positioned(
            top: 12,
            left: 8,
            child: SafeArea(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.onSurface,
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
                        // Create Account Header
                        const SizedBox(height: 16),
                        Text(
                          'Create account',
                          textAlign: TextAlign.left,
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
                          'Join the harmony of high-end audio and focus.',
                          textAlign: TextAlign.left,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Full Name Field
                        CustomTextField(
                          hint: 'Enter your name',
                          label: 'Full Name',
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          prefixIcon: Icons.person_outline_rounded,
                          focusNode: _nameFocus,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_emailFocus),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Enter your name';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Email Address Field
                        CustomTextField(
                          hint: 'you@example.com',
                          label: 'Email Address',
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

                        // Password Field
                        CustomTextField(
                          hint: 'Create a strong password',
                          label: 'Password',
                          controller: _passwordController,
                          isPassword: true,
                          prefixIcon: Icons.lock_outline_rounded,
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _onCreateAccount(),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter a password';
                            if (v.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 32),

                        // Create Account Button
                        CustomButton(
                          label: 'Create Account',
                          onTap: _onCreateAccount,
                        ),

                        const SizedBox(height: 24),

                        // Divider
                        const _OrDivider(),

                        const SizedBox(height: 24),

                        // Google Sign Up
                        CustomButton(
                          label: 'Sign up with Google',
                          variant: ButtonVariant.ghost,
                          leadingWidget: const _GoogleIcon(),
                          onTap: () async {
                            final success = await signInWithGoogle();

                            if (!mounted) return;

                            if (success) {
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

                        // Sign in link
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: RichText(
                              text: TextSpan(
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                  fontSize: 16,
                                ),
                                children: [
                                  const TextSpan(text: 'Already have an account? '),
                                  TextSpan(
                                    text: 'Sign in',
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

                        const SizedBox(height: 32),
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
            'or continue with',
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
