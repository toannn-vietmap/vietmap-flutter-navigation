import 'package:demo_plugin_example/core/extension/color_extension.dart';
import 'package:flutter/material.dart';

class RouteControlButtons extends StatelessWidget {
  final VoidCallback onStartNavigation;
  final VoidCallback onClearRoute;
  final VoidCallback onEditWaypoints;

  const RouteControlButtons({
    super.key,
    required this.onStartNavigation,
    required this.onClearRoute,
    required this.onEditWaypoints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PrimaryButton(
              onPressed: onStartNavigation,
              label: 'Bắt đầu',
              icon: Icons.navigation_outlined,
              backgroundColor: const Color(0xFF4CAF50),
            ),
            const SizedBox(width: 12),
            SecondaryButton(
              onPressed: onClearRoute,
              label: 'Xoá tuyến',
              icon: Icons.clear_outlined,
              backgroundColor: const Color(0xFFF44336),
            ),
            const SizedBox(width: 12),
            SecondaryButton(
              onPressed: onEditWaypoints,
              label: 'Chỉnh sửa',
              icon: Icons.edit_location_alt_outlined,
              backgroundColor: const Color(0xFF2196F3),
            ),
          ],
        ),
      ),
    );
  }
}

/// Primary Button - Nút chính với gradient và bóng đổ
class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color backgroundColor;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            backgroundColor,
            backgroundColor.withOpacityCustom(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacityCustom(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacityCustom(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary Button - Nút phụ với Glass Morphism effect
class SecondaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color backgroundColor;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: backgroundColor.withOpacityCustom(0.15),
        border: Border.all(
          color: backgroundColor.withOpacityCustom(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityCustom(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter:
              const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
          child: Material(
            color: Colors.white.withOpacityCustom(0.9),
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(16),
              splashColor: backgroundColor.withOpacityCustom(0.2),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      color: backgroundColor,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        color: backgroundColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
