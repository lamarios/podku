import 'package:flutter/material.dart';
import 'package:podku/l10n/app_localizations.dart';

Future<bool?> okCancelDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  bool showCancel = true,
}) async {
  final locals = AppLocalizations.of(context)!;

  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: content,
      actions: <Widget>[
        if (showCancel) TextButton(onPressed: () => Navigator.pop(context, false), child: Text(locals.cancel)),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(locals.ok),
        ),
      ],
    ),
  );
}
