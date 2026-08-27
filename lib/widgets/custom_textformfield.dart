import 'package:flutter/services.dart';
import '../constants.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    required this.validator,
    required this.onSaved,
    this.controller,
    this.isObscure = false,
    required this.fontSize,
    this.fontColor,
    this.hintTextSize = 12,
    this.hintText = '',
    this.fillColor,
    required this.height,
    required this.width,
    this.keyboardType = TextInputType.text,
    this.maxLength = 200,
  });

  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final TextEditingController? controller;
  final bool isObscure;
  final double fontSize;
  final Color? fontColor;
  final double height, width;
  final double hintTextSize;
  final String hintText;
  final Color? fillColor;
  final TextInputType keyboardType;
  final int maxLength;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isObscure;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveTextColor = widget.fontColor ?? (isDark ? Colors.white : Colors.black);
    final effectiveFillColor = widget.fillColor ?? (isDark ? const Color(0xFF222222) : Colors.black12);

    return TextFormField(
      validator: widget.validator,
      onSaved: widget.onSaved,
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
      style: TextStyle(
        fontSize: widget.fontSize,
        color: effectiveTextColor,
        fontFamily: 'Frutiger',
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(
          widget.width,
          widget.height,
          widget.width,
          widget.height,
        ),
        focusColor: Colors.black,
        suffixIcon: widget.isObscure
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: isDark ? FB_LIGHT_PRIMARY : FB_DARK_PRIMARY,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? FB_SECONDARY : FB_DARK_PRIMARY,
            width: 1.5,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        errorStyle: const TextStyle(fontFamily: 'Frutiger'),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: FB_LIGHT_PRIMARY, width: 2),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        filled: true,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey[500] : Colors.black38,
          fontSize: widget.hintTextSize,
          fontFamily: 'Frutiger',
        ),
        hintText: widget.hintText,
        fillColor: effectiveFillColor,
      ),
    );
  }
}
