import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends ConsumerWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const CustomText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis, // ✅ default = ellipsis
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color ?? Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
    );
  }
}
