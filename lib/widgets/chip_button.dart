import 'package:flutter/material.dart';

class ChipButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color? buttonColor;
  const ChipButton(
      {required this.text,
      required this.onPressed,
      this.buttonColor,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: buttonColor == null
              ? LinearGradient(
                  colors: [
                    const Color(0xFF696ce4),
                    const Color(0xFF696ce4).withOpacity(0.9),
                    const Color(0xFF696ce4),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : LinearGradient(
                  colors: [
                    buttonColor!,
                    buttonColor!.withOpacity(0.9),
                    buttonColor!,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
