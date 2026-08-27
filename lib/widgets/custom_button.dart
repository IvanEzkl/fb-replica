import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import 'custom_font.dart';

class CustomButton extends StatefulWidget {
  final String buttonType;
  final String buttonName;
  final Color? fontColor;
  final Color? outlineColor;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    this.buttonType = 'elevated',
    required this.buttonName,
    this.fontColor,
    required this.onPressed,
    this.outlineColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.buttonType == 'outlined') {
      final borderCol = widget.outlineColor ?? (isDark ? FB_LIGHT_PRIMARY : FB_DARK_PRIMARY);
      final textCol = widget.fontColor ?? (isDark ? Colors.white : FB_DARK_PRIMARY);

      return OutlinedButton(
        onPressed: widget.onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderCol),
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: CustomFont(
          text: widget.buttonName,
          fontSize: ScreenUtil().setSp(13),
          color: textCol,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (widget.buttonType == 'text') {
      return TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(20),
            vertical: ScreenUtil().setHeight(10),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: CustomFont(
          text: widget.buttonName,
          fontSize: ScreenUtil().setSp(13),
          color: widget.fontColor ?? (isDark ? Colors.white : FB_PRIMARY),
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      // filled / elevated
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: FB_PRIMARY,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(20),
              vertical: ScreenUtil().setHeight(12),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: CustomFont(
            text: widget.buttonName,
            fontSize: ScreenUtil().setSp(14),
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
