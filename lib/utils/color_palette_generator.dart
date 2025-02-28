import 'dart:math' as math;

import 'package:flutter/material.dart';

List<Color> generatePalette(Color primaryColor, {int count = 12}) {
  // Convert to HSV for easier color manipulation
  final HSVColor baseHsv = HSVColor.fromColor(primaryColor);
  final List<Color> palette = [
    primaryColor,
  ]; // Start with the original primary color

  // Adjust to generate one fewer additional colors
  int remainingColors = count - 1;

  // Create a golden ratio-based distribution for pleasing color spacing
  const double goldenRatio = 0.618033988749895;
  double hue = baseHsv.hue / 360.0;

  for (int i = 0; i < remainingColors; i++) {
    // Shift the hue by golden ratio for visually pleasing distribution
    hue += goldenRatio;
    hue %= 1.0;

    // Create color with same saturation and value but different hue
    final color =
        HSVColor.fromAHSV(
          1.0,
          hue * 360,
          // Slight random variation in saturation for better distinction
          math.min(
            baseHsv.saturation * (0.85 + 0.3 * math.Random().nextDouble()),
            1.0,
          ),
          // Keep brightness relatively consistent
          math.min(
            baseHsv.value * (0.9 + 0.2 * math.Random().nextDouble()),
            1.0,
          ),
        ).toColor();

    palette.add(color);
  }

  return palette;
}
