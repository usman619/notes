import 'package:flutter/material.dart';
import 'package:notes/extensions/buildcontext/loc.dart';
import 'package:notes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: context.loc.delete,
      content: context.loc.delete_note_prompt,
      optionBuilder: () => {
            context.loc.cancel: false,
            context.loc.yes: true,
          }).then(
    (value) => value ?? false,
  );
}
