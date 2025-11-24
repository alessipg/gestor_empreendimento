import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receitacerta/config/constants.dart';

class TextFieldApp extends StatelessWidget {
  const TextFieldApp({
    super.key,
    required this.textController,
    this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.textInputType,
    this.inputFormatters,
  });
  final TextEditingController? textController;
  final String? hintText;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 40,
        child: TextField(
          onChanged: onChanged,
          controller: textController,
          cursorColor: Colors.white,
          cursorHeight: 20,
          inputFormatters: [if (inputFormatters != null) ...inputFormatters!],
          keyboardType: textInputType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
            fillColor: UserColor.secondary,
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),

            hintText: hintText,
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: prefixIcon,
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            decorationThickness: 0.0,
          ),
        ),
      ),
    );
  }
}
