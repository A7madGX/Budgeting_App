import 'package:budgeting_app/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShimmerAnimated extends StatelessWidget {
  const ShimmerAnimated({
    super.key,
    this.color,
    this.enableAnimation = true,
    required this.child,
  });

  final Color? color;
  final bool enableAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enableAnimation) {
      return child;
    }

    return Animate(
      autoPlay: false,
      onInit: (c) => c.repeat(reverse: true),
      effects: [
        ShimmerEffect(
          duration: 2.seconds,
          delay: 500.ms,
          color: color ?? context.colorScheme.tertiary,
          curve: Curves.easeInOut,
        ),
      ],
      child: child,
    );
  }
}
