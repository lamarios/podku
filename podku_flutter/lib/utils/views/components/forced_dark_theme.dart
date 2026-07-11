import 'package:flutter/material.dart';
import 'package:podku/utils.dart';

class ForcedDarkThemeBuilder extends StatelessWidget {
  final Function(BuildContext context) builder;

  const ForcedDarkThemeBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: .fromSeed(
          seedColor: appColor,
          brightness: Brightness.dark,
        ),
      ),
      child: Builder(builder: (innerContext) => builder(innerContext)),
    );
  }
}
