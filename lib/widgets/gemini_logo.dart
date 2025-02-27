import 'package:budgeting_app/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GeminiLogo extends StatelessWidget {
  const GeminiLogo({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.colorScheme.primary;
    return SvgPicture.asset('assets/gemini.svg', width: size, height: size, colorFilter: ColorFilter.mode(color, BlendMode.srcATop));
  }
}
