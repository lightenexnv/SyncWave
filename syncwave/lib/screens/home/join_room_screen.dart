import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../player/now_playing_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _fullCode => _controllers.map((c) => c.text).join();

  bool get _isComplete => _fullCode.length == 6;

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onJoin() {
    if (!_isComplete) return;
    // TODO: Connect Firebase room lookup with code: _fullCode
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Back button + title
              Row(
                children: [
                  _BackButton(),
                  const SizedBox(width: 16),
                  Text('Join a Room', style: AppTextStyles.headingSmall),
                ],
              ),

              const SizedBox(height: 56),

              // Instruction text
              Center(
                child: Column(
                  children: [
                    Text('Enter Room Code', style: AppTextStyles.headingMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Ask the host for the 6-digit code',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // 6-digit boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return _DigitBox(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (value) {
                      _onDigitEntered(index, value);
                      setState(() {});
                    },
                    onBackspace: () {
                      if (_controllers[index].text.isEmpty && index > 0) {
                        _controllers[index - 1].clear();
                        _focusNodes[index - 1].requestFocus();
                        setState(() {});
                      }
                    },
                  );
                }),
              ),

              const SizedBox(height: 48),

              // Join button
              AnimatedOpacity(
                opacity: _isComplete ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 200),
                child: CustomButton(
                  label: 'Join Room',
                  onTap: _isComplete ? _onJoin : null,
                ),
              ),

              const SizedBox(height: 20),

              // Paste hint
              Center(
                child: TextButton.icon(
                  onPressed: () async {
                    final data = await Clipboard.getData('text/plain');
                    final text = data?.text ?? '';
                    final digits = text.replaceAll(RegExp(r'\D'), '');
                    if (digits.length >= 6) {
                      for (var i = 0; i < 6; i++) {
                        _controllers[i].text = digits[i];
                      }
                      setState(() {});
                      _focusNodes[5].requestFocus();
                    }
                  },
                  icon: const Icon(
                    Icons.content_paste_rounded,
                    color: AppColors.secondaryText,
                    size: 16,
                  ),
                  label: Text(
                    'Paste from clipboard',
                    style: AppTextStyles.label,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DigitBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _DigitBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 60,
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            onBackspace();
          }
        },
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: AppTextStyles.headingMedium,
          cursorColor: AppColors.accent,
          buildCounter:
              (_, {required currentLength, required isFocused, maxLength}) =>
                  null,
          decoration: InputDecoration(
            filled: true,
            fillColor: focusNode.hasFocus
                ? AppColors.accentSurface
                : AppColors.surfaceDark2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.primaryText,
          size: 18,
        ),
      ),
    );
  }
}
