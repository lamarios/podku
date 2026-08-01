import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:podku/utils.dart';

class PageTitle extends StatelessWidget {
  final String title;
  const PageTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = M3ETheme.of(context).textTheme;
    return Padding(
      padding: .only(bottom: pu2),
      child: Text(title, style: textTheme.titleLarge),
    );
  }
}
