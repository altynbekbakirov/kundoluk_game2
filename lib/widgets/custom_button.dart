import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, danger, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool fullWidth;
  final Widget? icon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.fullWidth = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;
    Color? borderColor;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = const Color(0xFF4F46E5);
        borderColor = const Color(0xFF6366F1);
        break;
      case ButtonVariant.secondary:
        backgroundColor = const Color(0xFF334155);
        borderColor = const Color(0xFF475569);
        break;
      case ButtonVariant.danger:
        backgroundColor = const Color(0xFFDC2626);
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        textColor = const Color(0xFF818CF8);
        borderColor = const Color(0xFF818CF8);
        break;
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
          elevation: variant == ButtonVariant.primary ? 8 : 4,
          shadowColor: variant == ButtonVariant.primary
              ? const Color(0xFF4F46E5).withOpacity(0.5)
              : Colors.black.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

