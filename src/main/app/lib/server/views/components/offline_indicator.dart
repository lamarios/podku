import 'package:flutter/material.dart';
import 'package:podku/l10n/app_localizations.dart';

class OfflineIndicator extends StatelessWidget {
  static double height = 20;

  const OfflineIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final locals = AppLocalizations.of(context)!;
    return SafeArea(
      child: Material(
        child: Builder(
          builder: (context) {
            final colors = Theme.of(context).colorScheme;
            return Container(
              height: height,
              alignment: .center,
              decoration: BoxDecoration(color: colors.errorContainer),
              child: Text(locals.offline, textAlign: .center),
            );
          },
        ),
      ),
    );
  }
}
