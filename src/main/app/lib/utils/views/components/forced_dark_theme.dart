import 'package:material_ui/material_ui.dart';
import 'package:podku/utils.dart';

class ForcedDarkThemeBuilder extends StatelessWidget {
  final Function(BuildContext context) builder;

  const ForcedDarkThemeBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: .fromSeed(seedColor: appColor, brightness: Brightness.dark),
      ),
      // re-bridge so dependencies still on package:flutter/material.dart also get the dark theme
      // ignore: deprecated_member_use
      child: MaterialUiCompatibilityBridge(child: Builder(builder: (innerContext) => builder(innerContext))),
    );
  }
}
