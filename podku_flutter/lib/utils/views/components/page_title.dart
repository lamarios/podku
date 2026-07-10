import 'package:flutter/material.dart';
import 'package:podku_flutter/utils.dart';

class PageTitle extends StatelessWidget {
  final String title;
  const PageTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: .only(bottom: pu2),
      child: Text(title, style: textTheme.titleLarge),
    );
  }
}
