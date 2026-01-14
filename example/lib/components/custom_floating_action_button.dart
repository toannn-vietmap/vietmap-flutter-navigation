import 'package:demo_plugin_example/core/extension/color_extension.dart';
import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String heroTag;
  final Color backgroundColor;
  final Color? foregroundColor;
  final String? tooltip;
  final double? size;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.heroTag,
    required this.backgroundColor,
    this.foregroundColor,
    this.tooltip,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacityCustom(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        heroTag: heroTag,
        tooltip: tooltip,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor ?? Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: size ?? 24,
        ),
      ),
    );
  }
}

/// Column chứa danh sách các FloatingActionButton
/// Tự động xử lý spacing giữa các button
class FloatingActionButtonGroup extends StatelessWidget {
  final List<Widget> buttons;
  final double spacing;

  const FloatingActionButtonGroup({
    super.key,
    required this.buttons,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: _buildButtonsWithSpacing(),
    );
  }

  List<Widget> _buildButtonsWithSpacing() {
    final List<Widget> widgets = [];
    for (int i = 0; i < buttons.length; i++) {
      widgets.add(buttons[i]);
      if (i < buttons.length - 1) {
        widgets.add(SizedBox(height: spacing));
      }
    }
    return widgets;
  }
}
