import 'dart:math' as Math;

import 'package:budgeting_app/extensions.dart';
import 'package:flutter/material.dart';

List<Color> generatePalette(BuildContext context, {int count = 12}) {
  return _ColorPaletteGenerator.generatePalette(
    context.colorScheme.primary,
    count: count,
  );
}

class _ColorPaletteGenerator {
  /// Converts a Color to HSL values
  static List<double> _rgbToHsl(Color color) {
    // Convert RGB values to 0-1 range
    double r = color.red / 255;
    double g = color.green / 255;
    double b = color.blue / 255;

    double max = [r, g, b].reduce((a, b) => a > b ? a : b);
    double min = [r, g, b].reduce((a, b) => a < b ? a : b);

    double h = 0;
    double s = 0;
    double l = (max + min) / 2;

    if (max != min) {
      double d = max - min;
      s = l > 0.5 ? d / (2 - max - min) : d / (max + min);

      if (max == r) {
        h = (g - b) / d + (g < b ? 6 : 0);
      } else if (max == g) {
        h = (b - r) / d + 2;
      } else if (max == b) {
        h = (r - g) / d + 4;
      }

      h /= 6;
    }

    return [h * 360, s * 100, l * 100];
  }

  /// Converts HSL values to a Color
  static Color _hslToColor(double h, double s, double l) {
    // Convert HSL percentages to decimals
    s = s / 100;
    l = l / 100;

    double c = (1 - (2 * l - 1).abs()) * s;
    double x = c * (1 - ((h / 60) % 2 - 1).abs());
    double m = l - c / 2;

    double r = 0, g = 0, b = 0;

    if (h < 60) {
      r = c;
      g = x;
      b = 0;
    } else if (h < 120) {
      r = x;
      g = c;
      b = 0;
    } else if (h < 180) {
      r = 0;
      g = c;
      b = x;
    } else if (h < 240) {
      r = 0;
      g = x;
      b = c;
    } else if (h < 300) {
      r = x;
      g = 0;
      b = c;
    } else {
      r = c;
      g = 0;
      b = x;
    }

    return Color.fromRGBO(
      ((r + m) * 255).round(),
      ((g + m) * 255).round(),
      ((b + m) * 255).round(),
      1,
    );
  }

  /// Generates a diverse palette of n colors based on the primary color
  static List<Color> generatePalette(Color primaryColor, {int count = 12}) {
    List<Color> palette = [];
    List<double> hsl = _rgbToHsl(primaryColor);

    double hue = hsl[0];
    double saturation = hsl[1];
    double lightness = hsl[2];

    // Generate variations by adjusting hue and lightness
    for (int i = 0; i < count; i++) {
      // Adjust hue by spreading colors around the wheel
      double newHue = (hue + (360 / count) * i) % 360;

      // Create more distinct variations by alternating lightness more dramatically
      double newLightness =
          lightness + (i % 3 - 1) * 15; // Alternate between -15, 0, and +15
      newLightness = newLightness.clamp(
        30,
        70,
      ); // Keep lightness in a readable range

      // Adjust saturation to maintain vibrancy
      double newSaturation = saturation.clamp(50, 90);

      palette.add(_hslToColor(newHue, newSaturation, newLightness));
    }

    return palette;
  }

  /// Generates a monochromatic palette based on the primary color with more distinct shades
  static List<Color> generateMonochromaticPalette(
    Color primaryColor, {
    int count = 12,
  }) {
    List<Color> palette = [];
    List<double> hsl = _rgbToHsl(primaryColor);

    double hue = hsl[0];
    double saturation = hsl[1].clamp(50.0, 90.0); // Ensure good saturation

    // Create more distinct variations by:
    // 1. Using a wider lightness range (15 to 85 instead of 30 to 70)
    // 2. Slightly varying saturation for more depth
    // 3. Using non-linear distribution for more contrast between adjacent colors
    for (int i = 0; i < count; i++) {
      // Create a non-linear distribution of lightness values
      // This formula creates more contrast between adjacent colors
      double t = i / (count - 1);
      double lightness = 15 + (85 - 15) * (1 - Math.cos(t * Math.pi)) / 2;

      // Vary saturation slightly based on lightness
      double adjustedSaturation = saturation + (lightness > 50 ? -10 : 10);
      adjustedSaturation = adjustedSaturation.clamp(40.0, 95.0);

      palette.add(_hslToColor(hue, adjustedSaturation, lightness));
    }

    // Sort by lightness to ensure a smooth gradient
    palette.sort((a, b) {
      final aHsl = _rgbToHsl(a);
      final bHsl = _rgbToHsl(b);
      return bHsl[2].compareTo(aHsl[2]); // Sort from lightest to darkest
    });

    return palette;
  }

  /// Generates an analogous palette based on the primary color
  static List<Color> generateAnalogousPalette(
    Color primaryColor, {
    int count = 12,
  }) {
    List<Color> palette = [];
    List<double> hsl = _rgbToHsl(primaryColor);

    double hue = hsl[0];
    double saturation = hsl[1].clamp(50.0, 90.0);
    double baseLightness = hsl[2].clamp(35.0, 65.0);

    // Generate variations with wider hue range and lightness variations
    double hueRange = 60; // Increased from 30 to 60 degrees
    for (int i = 0; i < count; i++) {
      // Calculate hue variation
      double t = i / (count - 1);
      double hueOffset = -hueRange + (2 * hueRange * t);
      double newHue = (hue + hueOffset) % 360;

      // Vary lightness based on position
      double lightness =
          baseLightness + (i % 3 - 1) * 15; // Varies by -15, 0, or +15
      lightness = lightness.clamp(30.0, 70.0);

      // Vary saturation slightly for more interest
      double adjustedSaturation = saturation + (i % 2 == 0 ? 5 : -5);

      palette.add(_hslToColor(newHue, adjustedSaturation, lightness));
    }

    return palette;
  }
}
