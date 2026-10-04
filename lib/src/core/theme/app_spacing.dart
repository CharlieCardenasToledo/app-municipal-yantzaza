import 'package:flutter/widgets.dart';

/// Consistent spacing scale for Mi Yantzaza.
/// Follows the "generous white space" principle: if you think
/// there's enough space, add 8px more.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Edge insets
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets cardPaddingLg = EdgeInsets.all(lg);
}
