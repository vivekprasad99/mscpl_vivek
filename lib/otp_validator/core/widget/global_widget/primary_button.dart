import 'package:flutter/material.dart';
import 'package:mscpl_vivek/otp_validator/core/utils/custom_colors.dart';

class PrimaryButton extends StatelessWidget {
  final Color? color;
  final String text;
  final VoidCallback? onPressed;
  final Widget? child;
  final double fontSize;
  final Color textColor;
  final double borderRadius;
  const PrimaryButton(
      {Key? key,
      this.color = titleTextColor,
      required this.onPressed,
      this.text = "",
      this.child,
      this.fontSize = 16,
      this.textColor = Colors.white,
      this.borderRadius = 8.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          width: double.infinity,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: buttonBorderColor)
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
