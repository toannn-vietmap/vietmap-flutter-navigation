import 'dart:ui';

import 'package:demo_plugin_example/components/reoder_waypoint_item.dart';
import 'package:flutter/material.dart';
import 'package:vietmap_flutter_navigation/models/marker_widget.dart';

class ReoderWaypointWidget extends StatefulWidget {
  final List<LatLng> waypoints;
  final Function(List<LatLng>)? onWaypointsChanged;
  final Function(int)? onWaypointTap;
  final Function(int)? onWaypointDelete;
  final VoidCallback? onBack;

  const ReoderWaypointWidget({
    super.key,
    required this.waypoints,
    this.onWaypointsChanged,
    this.onWaypointTap,
    this.onWaypointDelete,
    this.onBack,
  });

  @override
  State<ReoderWaypointWidget> createState() => _ReoderWaypointWidgetState();
}

class _ReoderWaypointWidgetState extends State<ReoderWaypointWidget> {
  late List<LatLng> _waypoints;

  @override
  void initState() {
    super.initState();
    _waypoints = List<LatLng>.from(widget.waypoints);
  }

  @override
  void didUpdateWidget(ReoderWaypointWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.waypoints != oldWidget.waypoints) {
      _waypoints = List<LatLng>.from(widget.waypoints);
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    debugPrint('Reorder from $oldIndex to $newIndex');
    if (oldIndex == newIndex) return;
    if (oldIndex < newIndex) {
      _waypoints.insert(newIndex, _waypoints[oldIndex]);
      _waypoints.removeAt(oldIndex);
      setState(() {});
    } else {
      final LatLng item = _waypoints.removeAt(oldIndex);
      _waypoints.insert(newIndex, item);
      setState(() {});
    }

    widget.onWaypointsChanged?.call(_waypoints);
  }

  Widget _buildWaypointItem(BuildContext context, int index) {
    final isFirst = index == 0;
    final isLast = index == _waypoints.length - 1;

    String hintText;
    String? prefixChar;

    if (isFirst) {
      hintText = 'Điểm xuất phát';
      prefixChar = 'A';
    } else if (isLast && _waypoints.length > 1) {
      hintText = 'Điểm đến';
      prefixChar = 'B';
    } else {
      hintText = 'Điểm dừng $index';
      prefixChar = '$index';
    }

    return Padding(
      key: Key('waypoint_$index'),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: ReoderWaypointItem(
        hintText: hintText,
        heroTag: 'waypoint_hero_$index',
        prefixChar: prefixChar,
        onTap: () => widget.onWaypointTap?.call(index),
        onDelete: _waypoints.length > 2
            ? () {
                setState(() {
                  _waypoints.removeAt(index);
                });
                widget.onWaypointDelete?.call(index);
              }
            : null,
      ),
    );
  }

  Widget _buildAddWaypointItem() {
    return Padding(
      key: const Key('add_waypoint'),
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
      child: ReoderWaypointItem(
        hintText: 'Quay lại',
        heroTag: 'add_waypoint_hero',
        isEndItem: true,
        onTap: widget.onBack,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: _waypoints.length + 1,
      itemBuilder: (context, index) {
        if (index < _waypoints.length) {
          return _buildWaypointItem(context, index);
        } else {
          return _buildAddWaypointItem();
        }
      },
      onReorder: (oldIndex, newIndex) {
        if (oldIndex >= _waypoints.length || newIndex > _waypoints.length) {
          return;
        }
        _onReorder(oldIndex, newIndex);
      },
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            final double animValue =
                Curves.easeInOut.transform(animation.value);
            final double elevation = lerpDouble(0, 6, animValue)!;
            return Material(
              elevation: elevation,
              borderRadius: BorderRadius.circular(10),
              child: child,
            );
          },
          child: child,
        );
      },
    );
  }
}
