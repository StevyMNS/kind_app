import 'package:flutter/material.dart';

/// Rayons de bordure globaux.
class AppRadius {
  AppRadius._();

  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;
  static const double circular = 100.0;

  static BorderRadius get smallRadius => BorderRadius.circular(small);
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);
  static BorderRadius get largeRadius => BorderRadius.circular(large);
  static BorderRadius get extraLargeRadius => BorderRadius.circular(extraLarge);
  static BorderRadius get circularRadius => BorderRadius.circular(circular);
}
