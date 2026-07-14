import 'package:flutter/material.dart';
import 'package:podku/utils.dart';

class SwipeActionButton extends StatelessWidget {
  final Color color;
  final Widget icon;

  const SwipeActionButton({super.key, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: .circular(50),
        ),
        padding: .all(pu2),
        child: icon,
      ),
    );
  }
}
