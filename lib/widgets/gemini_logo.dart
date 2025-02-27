import 'package:budgeting_app/extensions.dart';
import 'package:budgeting_app/widgets/shimmer_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

class GeminiLogo extends StatelessWidget {
  const GeminiLogo({
    super.key,
    this.size = 24,
    this.enableAnimations = false,
    this.color,
  });

  final double size;
  final bool enableAnimations;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.colorScheme.primary;

    return Animate(
      key: ValueKey(enableAnimations),
      autoPlay: false,
      onInit: (c) {
        if (enableAnimations) {
          c.repeat();
        }
      },
      effects: [
        if (enableAnimations) ...[
          ScaleEffect(
            delay: const Duration(milliseconds: 200),
            begin: const Offset(1.0, 1.0),
            end: Offset(0.7, 0.7),
            duration: const Duration(milliseconds: 150),
          ),
          ScaleEffect(
            delay: const Duration(milliseconds: 350),
            begin: const Offset(1.0, 1.0),
            end: Offset(1.4, 1.4),
            duration: const Duration(milliseconds: 150),
          ),
        ],
        ShimmerAnimated.getShimmerEffect(),
        ShakeEffect(
          delay: const Duration(milliseconds: 1000),
          duration: const Duration(milliseconds: 500),
          hz: 1,
        ),
      ],
      child: SvgPicture.asset(
        'assets/gemini.svg',
        width: size,
        height: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      ),
    );
  }
}
