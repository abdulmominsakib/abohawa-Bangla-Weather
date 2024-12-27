import 'package:flutter/material.dart';

extension ColorWithUtils on Color {
  Color withOpacityValue(double opacity) => withAlpha((opacity * 255).round());
}
