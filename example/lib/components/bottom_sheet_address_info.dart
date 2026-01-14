import 'package:demo_plugin_example/core/extension/color_extension.dart';
import 'package:flutter/material.dart';

import '../data/models/vietmap_reverse_model.dart';
import 'custom_action_button.dart';

class AddressInfo extends StatelessWidget {
  final VietmapReverseModel data;
  final VoidCallback buildRoute;
  final VoidCallback buildAndStartRoute;
  final VoidCallback addWaypoint;
  final VoidCallback removeAllMarkers;
  const AddressInfo(
      {super.key,
      required this.data,
      required this.buildRoute,
      required this.buildAndStartRoute,
      required this.addWaypoint,
      required this.removeAllMarkers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location icon and name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacityCustom(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: Color(0xFF2196F3),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.name ?? 'Địa điểm',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.address ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Action buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CustomActionButton(
                        onPressed: buildAndStartRoute,
                        label: 'Bắt đầu',
                        icon: Icons.navigation_outlined,
                        style: ActionButtonStyle.filled,
                        backgroundColor: const Color(0xFF4CAF50),
                        size: ActionButtonSize.large,
                      ),
                      const SizedBox(width: 12),
                      CustomActionButton(
                        onPressed: buildRoute,
                        label: 'Đường đi',
                        icon: Icons.route_outlined,
                        style: ActionButtonStyle.tonal,
                        backgroundColor: const Color(0xFF2196F3),
                        size: ActionButtonSize.large,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Secondary actions
                Row(
                  children: [
                    CustomActionButton(
                      onPressed: addWaypoint,
                      label: 'Thêm điểm dừng',
                      icon: Icons.add_location_alt_outlined,
                      style: ActionButtonStyle.outlined,
                      backgroundColor: const Color(0xFF2196F3),
                    ),
                    const SizedBox(width: 12),
                    CustomActionButton(
                      onPressed: removeAllMarkers,
                      label: 'Xoá tất cả',
                      icon: Icons.delete_outline,
                      style: ActionButtonStyle.outlined,
                      backgroundColor: const Color(0xFFF44336),
                    ),
                  ],
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
