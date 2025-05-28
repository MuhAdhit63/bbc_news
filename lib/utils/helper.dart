import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF757575);
}

class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;

  static Widget vertical(double size) => SizedBox(height: size);
  static Widget horizontal(double size) => SizedBox(width: size);
}

class AppDivider {
  static Widget spaceDivider({double thickness = 1.0, Color color = Colors.grey}) {
    return Divider(thickness: thickness, color: color);
  }
}

class AppFontWeight {
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight bold = FontWeight.w700;
}

class AppFontSize {
  static const double small = 12.0;
  static const double medium = 16.0;
  static const double large = 20.0;
  static const double extraLarge = 24.0;
}

class AppBorders {
  static BorderRadius borderRadiusSmall = BorderRadius.circular(8.0);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(16.0);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(24.0);

  static Border border({Color color = Colors.grey, double width = 1.0}) {
    return Border.all(color: color, width: width);
  }
}

class AppBoxDecoration {
  static BoxDecoration boxDecoration({
    Color color = Colors.white,
    BorderRadius? borderRadius,
    Border? border,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
      border: border,
      boxShadow: boxShadow,
    );
  }
}