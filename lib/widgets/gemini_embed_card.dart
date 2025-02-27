import 'dart:math';

import 'package:budgeting_app/extensions.dart';
import 'package:flutter/material.dart';

class GeminiEmbedCard extends StatefulWidget {
  const GeminiEmbedCard({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    this.enableGlowAnimation = true,
    this.borderRadius = cardBorderRadius,
    required this.child,
  });

  final EdgeInsets padding;
  final bool enableGlowAnimation;
  final Widget child;
  final double borderRadius;

  static const double gradientBorderWidth = 3;
  static const double cardBorderRadius = 24;
  static const Duration animationDuration = Duration(seconds: 3);

  @override
  State<GeminiEmbedCard> createState() => _GeminiEmbedCardState();
}

class _GeminiEmbedCardState extends State<GeminiEmbedCard>
    with TickerProviderStateMixin {
  late final AnimationController _borderController;
  late final AnimationController _shadowController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: GeminiEmbedCard.animationDuration,
    )..repeat();

    _shadowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final color1 = context.colorScheme.primary;
    final color2 = context.colorScheme.tertiaryContainer;

    return AnimatedBuilder(
      animation: _borderController,
      builder: (context, child) {
        final padding =
            widget.enableGlowAnimation
                ? GeminiEmbedCard.gradientBorderWidth
                : 0.0;
        return Container(
          // duration: Duration(milliseconds: 500),
          // curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color1.withAlpha(widget.enableGlowAnimation ? 255 : 0),
                color2.withAlpha(widget.enableGlowAnimation ? 255 : 0),
              ],
              transform: GradientRotation(
                Curves.easeInOut.transform(_borderController.value) * 2 * pi,
              ),
            ),
            // Animated Shadow
            boxShadow: [
              BoxShadow(
                color: (Color.lerp(color1, color2, _shadowController.value) ??
                        Colors.transparent)
                    .withValues(alpha: widget.enableGlowAnimation ? 0.5 : 0),
                blurRadius: _shadowController.value * 4 + 12,
                spreadRadius: _shadowController.value * 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: padding,
            ),
            child: child,
          ),
        );
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: widget.padding,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          widget.borderRadius - GeminiEmbedCard.gradientBorderWidth,
        ),
        // color is scaffold background if enable glow animation
        color:
            widget.enableGlowAnimation
                ? context.colorScheme.surfaceContainerLowest
                : context.colorScheme.surfaceContainerHigh,
      ),
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _borderController.dispose();
    _shadowController.dispose();
    super.dispose();
  }
}
