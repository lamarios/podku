import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/buttons/m3e_buttons.dart';
import 'package:material_3_expressive/components/dialogs/m3e_dialogs.dart';
import 'package:podku/l10n/app_localizations.dart';

Future<bool?> okCancelDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  bool showCancel = true,
}) async {
  final locals = AppLocalizations.of(context)!;

  return await M3EDialog.show<bool>(
    context,
    dialog: M3EDialog(
      title: title,
      content: content,
      actions: <Widget>[
        if (showCancel)
          Builder(
            builder: (context) {
              return M3EButton.text(onPressed: () => Navigator.pop(context, false), child: Text(locals.cancel));
            },
          ),
        Builder(
          builder: (context) {
            return M3EButton.text(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(locals.ok),
            );
          },
        ),
      ],
    ),
  );
}
