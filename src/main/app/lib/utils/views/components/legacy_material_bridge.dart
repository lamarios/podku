import 'package:material_ui/material_ui.dart';

/// Gives the material_ui theme and localizations to dependencies that still use package:flutter/material.dart.
///
/// Wraps [MaterialUiCompatibilityBridge] and keeps the surrounding [IconTheme]: the legacy Theme it inserts also
/// inserts an IconTheme built from its ThemeData, which would override the one set by M3ETheme.
///
/// Remove once all the dependencies migrated to material_ui.
class LegacyMaterialBridge extends StatelessWidget {
  final Widget child;

  const LegacyMaterialBridge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    // ignore: deprecated_member_use
    return MaterialUiCompatibilityBridge(
      child: IconTheme(data: iconTheme, child: child),
    );
  }
}
