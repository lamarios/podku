import 'package:material_ui/material_ui.dart';
import 'package:podku/utils.dart';
import 'package:podku/utils/views/components/legacy_material_bridge.dart';

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
      child: LegacyMaterialBridge(child: Builder(builder: (innerContext) => builder(innerContext))),
    );
  }
}
