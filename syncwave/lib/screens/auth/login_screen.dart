import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Connect Firebase Auth sign-in here
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.pagePaddingH,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppConstants.spacingXl),

                  // Header Section
                  _Header(),

                  const SizedBox(height: AppConstants.spacingXxl),

                  // Email Field
                  CustomTextField(
                    hint: 'your@email.com',
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline_rounded,
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        FocusScope.of(context).requestFocus(_passwordFocus),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter your email';
                      if (!v.contains('@')) return 'Enter a valid email';
                      return null;
                    },
                  ),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Password Field
                  CustomTextField(
                    hint: 'Password',
                    label: 'Password',
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

                  const SizedBox(height: AppConstants.spacingSm),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Navigate to forgot password screen
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 4,
                        ),
                      ),
                      child: Text(
                        'Forgot password?',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingLg),

                  // Continue Button
                  CustomButton(label: 'Continue', onTap: _onContinue),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Divider
                  _OrDivider(),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Google Sign In
                  CustomButton(
                    label: 'Continue with Google',
                    variant: ButtonVariant.ghost,
                    leadingWidget: _GoogleIcon(),
                    onTap: () {
                      // TODO: Connect Google Sign-In here
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),

                  const SizedBox(height: AppConstants.spacingXl),

                  // Sign up link
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/signup'),
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign up',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingXl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome back', style: AppTextStyles.headingLarge),
        const SizedBox(height: 8),
        Text(
          'Sign in to continue listening with your friends.',
          style: AppTextStyles.body.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: AppTextStyles.caption.copyWith(color: AppColors.outline),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleIcon extends StatelessWidget {
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

    // Simplified Google G
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'G',
        style: GoogleFonts.inter(
          fontSize: size.width * 0.85,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4285F4),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(cx - textPainter.width / 2, cy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
