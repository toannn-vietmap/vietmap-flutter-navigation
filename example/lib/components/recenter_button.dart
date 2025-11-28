import 'package:demo_plugin_example/core/extension/color_extension.dart';
import 'package:flutter/material.dart';

/// Nút Recenter - Đưa camera về vị trí hiện tại
/// Hiển thị khi người dùng di chuyển camera khỏi vị trí tracking
class RecenterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RecenterButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(25),
        shadowColor: const Color(0xFF2196F3).withOpacityCustom(0.3),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              border: Border.all(
                color: const Color(0xFF2196F3).withOpacityCustom(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: const Icon(
                    Icons.navigation_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Về giữa',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2196F3),
                    fontWeight: FontWeight.w600,
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
