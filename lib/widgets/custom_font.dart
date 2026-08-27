import 'package:flutter/material.dart';

class CustomFont extends StatelessWidget {
  const CustomFont({
    super.key,
    required this.text,
    required this.fontSize,
    this.color,
    this.fontFamily = 'Frutiger',
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.letterSpacing = 0,
    this.fontStyle = FontStyle.normal,
  });

  final String text;
  final double fontSize, letterSpacing;
  final Color? color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final String fontFamily;
  final FontStyle fontStyle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color effectiveColor;

    if (color == null || color == Colors.black) {
      effectiveColor = isDark ? Colors.white : Colors.black;
    } else if (color == Colors.black87) {
      effectiveColor = isDark ? Colors.white70 : Colors.black87;
    } else if (color == Colors.black54) {
      effectiveColor = isDark ? Colors.white60 : Colors.black54;
    } else {
      effectiveColor = color!;
    }

    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: effectiveColor,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
