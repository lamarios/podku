import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:podku/utils.dart';

class BottomSheetTitle extends StatelessWidget {
  final String title;
  final Widget? icon;

  const BottomSheetTitle({super.key, required this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;

    return Padding(
      padding: .only(top: pu2, left: pu2, right: pu2),
      child: Row(
        spacing: pu4,
        children: [
          ?icon,
          Expanded(
            child: Text(title, maxLines: 2, overflow: .ellipsis, style: textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}
