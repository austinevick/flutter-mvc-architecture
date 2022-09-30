import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Widget? child;
  final Color? color;
  final double? width;
  final double? height;
  final Color? textColor;
  final BorderSide? borderSide;
  final TextStyle? textStyle;
  final double? radius;
  const CustomButton(
      {Key? key,
      this.onPressed,
      this.textColor = Colors.white,
      this.text,
      this.radius = 5,
      this.color,
      this.child,
      this.width = double.infinity,
      this.height,
      this.borderSide,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 60,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        elevation: 0,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: borderSide ?? BorderSide.none),
        child: child ??
            Text(text!,
                style: textStyle ??
                    TextStyle(
                        color: textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
      ),
    );
  }
}
