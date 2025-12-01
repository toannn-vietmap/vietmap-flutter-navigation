import 'package:flutter/widgets.dart';

extension ColorExtension on Color {
  Color withOpacityCustom(double opacity) {
    return withAlpha((opacity * 255).round());
  }
}
