import 'package:demo_plugin_example/core/extension/color_extension.dart';
import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  /// Callback khi button được nhấn
  final VoidCallback onPressed;

  /// Text hiển thị trên button
  final String label;

  /// Icon hiển thị (optional)
  final IconData? icon;

  /// Style của button: filled, outlined, tonal
  final ActionButtonStyle style;

  /// Màu chủ đạo của button
  final Color? backgroundColor;

  /// Layout của button: horizontal (icon-text ngang), vertical (icon-text dọc)
  final ActionButtonLayout layout;

  /// Kích thước của button: small, medium, large
  final ActionButtonSize size;

  /// Border radius (optional, mặc định theo size)
  final double? borderRadius;

  /// Expand button full width
  final bool expanded;

  /// Enable/disable button
  final bool enabled;

  /// Custom icon size
  final double? iconSize;

  /// Custom text style
  final TextStyle? textStyle;

  const CustomActionButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.style = ActionButtonStyle.filled,
    this.backgroundColor,
    this.layout = ActionButtonLayout.horizontal,
    this.size = ActionButtonSize.medium,
    this.borderRadius,
    this.expanded = false,
    this.enabled = true,
    this.iconSize,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBackgroundColor = backgroundColor ?? theme.primaryColor;

    Widget buttonContent = _buildButtonContent(effectiveBackgroundColor);

    if (expanded) {
      buttonContent = SizedBox(
        width: double.infinity,
        child: buttonContent,
      );
    }

    return buttonContent;
  }

  Widget _buildButtonContent(Color effectiveBackgroundColor) {
    switch (style) {
      case ActionButtonStyle.filled:
        return _buildFilledButton(effectiveBackgroundColor);
      case ActionButtonStyle.outlined:
        return _buildOutlinedButton(effectiveBackgroundColor);
      case ActionButtonStyle.tonal:
        return _buildTonalButton(effectiveBackgroundColor);
    }
  }

  /// Filled Button - Background đầy màu
  Widget _buildFilledButton(Color bgColor) {
    return Material(
      color: enabled ? bgColor : bgColor.withOpacityCustom(0.5),
      borderRadius:
          BorderRadius.circular(borderRadius ?? _getDefaultBorderRadius()),
      elevation: enabled ? 2 : 0,
      shadowColor: bgColor.withOpacityCustom(0.4),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius:
            BorderRadius.circular(borderRadius ?? _getDefaultBorderRadius()),
        child: Container(
          padding: _getPadding(),
          child: _buildButtonChild(
            iconColor: Colors.white,
            textColor: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Outlined Button - Viền outline
  Widget _buildOutlinedButton(Color color) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(borderRadius ?? _getDefaultBorderRadius()),
        side: BorderSide(
          color: enabled
              ? color.withOpacityCustom(0.3)
              : color.withOpacityCustom(0.1),
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius:
            BorderRadius.circular(borderRadius ?? _getDefaultBorderRadius()),
        child: Container(
          padding: _getPadding(),
          child: _buildButtonChild(
            iconColor: enabled ? color : color.withOpacityCustom(0.5),
            textColor: enabled ? color : color.withOpacityCustom(0.5),
          ),
        ),
      ),
    );
  }

  /// Tonal Button - Background màu nhạt
  Widget _buildTonalButton(Color color) {
    return Material(
      color: enabled
          ? color.withOpacityCustom(0.1)
          : color.withOpacityCustom(0.05),
      borderRadius:
          BorderRadius.circular(borderRadius ?? _getDefaultBorderRadius()),
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius:
            BorderRadius.circular(borderRadius ?? _getDefaultBorderRadius()),
        child: Container(
          padding: _getPadding(),
          child: _buildButtonChild(
            iconColor: enabled ? color : color.withOpacityCustom(0.5),
            textColor: enabled ? color : color.withOpacityCustom(0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonChild({
    required Color iconColor,
    required Color textColor,
  }) {
    final effectiveIconSize = iconSize ?? _getDefaultIconSize();
    final effectiveTextStyle = textStyle ?? _getDefaultTextStyle(textColor);

    if (layout == ActionButtonLayout.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: iconColor, size: effectiveIconSize),
          if (icon != null) const SizedBox(height: 4),
          Text(label, style: effectiveTextStyle, textAlign: TextAlign.center),
        ],
      );
    }

    // Horizontal layout
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) Icon(icon, color: iconColor, size: effectiveIconSize),
        if (icon != null) SizedBox(width: _getIconTextSpacing()),
        Text(label, style: effectiveTextStyle),
      ],
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ActionButtonSize.small:
        return layout == ActionButtonLayout.vertical
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ActionButtonSize.medium:
        return layout == ActionButtonLayout.vertical
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
            : const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case ActionButtonSize.large:
        return layout == ActionButtonLayout.vertical
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
            : const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    }
  }

  double _getDefaultBorderRadius() {
    switch (size) {
      case ActionButtonSize.small:
        return 8.0;
      case ActionButtonSize.medium:
        return 12.0;
      case ActionButtonSize.large:
        return 16.0;
    }
  }

  double _getDefaultIconSize() {
    switch (size) {
      case ActionButtonSize.small:
        return 16.0;
      case ActionButtonSize.medium:
        return 20.0;
      case ActionButtonSize.large:
        return 24.0;
    }
  }

  double _getIconTextSpacing() {
    switch (size) {
      case ActionButtonSize.small:
        return 4.0;
      case ActionButtonSize.medium:
        return 6.0;
      case ActionButtonSize.large:
        return 8.0;
    }
  }

  TextStyle _getDefaultTextStyle(Color textColor) {
    switch (size) {
      case ActionButtonSize.small:
        return TextStyle(
          color: textColor,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        );
      case ActionButtonSize.medium:
        return TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );
      case ActionButtonSize.large:
        return TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );
    }
  }
}

/// Style của ActionButton
enum ActionButtonStyle {
  /// Background đầy màu với text trắng
  filled,

  /// Viền outline với background transparent
  outlined,

  /// Background màu nhạt (opacity 0.1)
  tonal,
}

/// Layout của icon và text
enum ActionButtonLayout {
  /// Icon và text nằm ngang
  horizontal,

  /// Icon ở trên, text ở dưới
  vertical,
}

/// Kích thước của button
enum ActionButtonSize {
  small,
  medium,
  large,
}
