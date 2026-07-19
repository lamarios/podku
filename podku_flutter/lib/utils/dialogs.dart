import 'package:flutter/material.dart';

Future<bool?> okCancelDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  bool showCancel = true,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: content,
      actions: <Widget>[
        if (showCancel) TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Ok'),
        ),
      ],
    ),
  );
}
